// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/domain/models/firestore/share_model.dart';
import 'package:farmbov/src/domain/models/global_farm_model.dart';
import 'package:farmbov/src/domain/repositories/farm_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/models/area_usage_type_model.dart';
import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/domain/models/firestore/farm_model.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

class FarmUpdatePageStore extends MobXStore<FarmModel?> {
  FarmUpdatePageStore() : super(null);

  final formKey = GlobalKey<FormState>();

  TextEditingController? nameController = TextEditingController();
  TextEditingController? areaController = TextEditingController();
  TextEditingController? latitudeController = TextEditingController();
  TextEditingController? longitudeController = TextEditingController();

  final FarmRepository _repository = FarmRepositoryImpl();

  final selectedUsageType = Observable<AreaUsageTypeModel?>(null);

  init({FarmModel? model}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadModel(model: model);
    });
  }

  dispose() {
    nameController?.dispose();
    areaController?.dispose();
    latitudeController?.dispose();
    longitudeController?.dispose();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final location = await Geolocator.getCurrentPosition();
    latitudeController?.text = location.latitude.toString();
    longitudeController?.text = location.longitude.toString();
  }

  void _loadModel({FarmModel? model}) {
    if (model == null) {
      _getLocation();
      return;
    }

    nameController?.text = model.name ?? '';
    areaController?.text = model.area?.toString() ?? "0";
    latitudeController?.text = model.latitude ?? '';
    longitudeController?.text = model.longitude ?? '';
    update(model);
  }

  void selectUsageType(AreaUsageTypeModel? type) {
    selectedUsageType.value = type;
  }

  void insert(BuildContext context) async {
    try {
      setLoading(true);

      if (formKey.currentState == null ||
          formKey.currentState?.validate() == false) {
        return;
      }

      final model = createFarmData(
        ownerId: FirebaseAuth.instance.currentUser?.uid,
        name: nameController?.text ?? '',
        area: double.tryParse(areaController?.text ?? '0') ?? 0.0,
        latitude: latitudeController?.text ?? '',
        longitude: longitudeController?.text ?? '',
        create: true,
      );

      final savedFarm = await saveFarm(model);

      showInsertSuccessModal(context);

      AppManager.instance.updateFarm(
        context,
        GlobalFarmModel(
          id: savedFarm.id,
          name: model["name"],
          userId: model["owner_id"],
        ),
        fromInsert: true,
      );
    } catch (e) {
      setError(e as Exception);
      AlertManager.showToast('Erro ao salvar! Tente ovamente em alguns minutos.');
    } finally {
      setLoading(false);
    }
  }

  // Move it to a repository
  Future<DocumentReference<Map<String, dynamic>>> saveFarm(
      Map<String, dynamic> data) async {
    final farms = FirebaseFirestore.instance.collection('farms');
    final farmRef = await farms.add(data);

    await cloneAppDefaultValuesToFarm(farmRef);

    return farmRef;
  }

  Future<void> cloneAppDefaultValuesToFarm(DocumentReference farmRef) async {
    // Referência ao documento `app_default_values`
    final appDefaultsRef = FirebaseFirestore.instance
        .collection('configurations')
        .doc('app_default_values');

    // Batch para garantir que todas as operações sejam executadas de uma só vez
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Nomes das coleções dentro de 'app_default_values' que você deseja clonar
    final List<String> collectionsToClone = [
      'animal_down_reasons',
      'animal_breeds',
      'drug_administration_types',
      'vaccines'
    ];

    try {
      // Itera sobre cada coleção e clona seus documentos
      for (String collectionName in collectionsToClone) {
        // Obtém os documentos da coleção em `app_default_values`
        QuerySnapshot collectionSnapshot =
            await appDefaultsRef.collection(collectionName).get();

        // Para cada documento na coleção
        for (QueryDocumentSnapshot doc in collectionSnapshot.docs) {
          // Cria uma nova referência de documento dentro da farm com o mesmo ID
          DocumentReference newDocRef = farmRef
              .collection(collectionName) // A mesma coleção na farm
              .doc(doc.id); // Mantém o mesmo ID do documento

          // Adiciona a operação de criação ao batch
          batch.set(newDocRef, doc.data());
        }
      }

      // Realiza todas as operações em lote
      await batch.commit();
    } catch (e) {
      throw Exception(
          'Error ao tentar clonar valores padrões para cada fazenda!');
    }
  }

  void edit(
    DocumentReference model,
    BuildContext context,
  ) async {
    try {
      setLoading(true);

      if (formKey.currentState == null ||
          formKey.currentState?.validate() == false) {
        return;
      }

      final updatedModel = createFarmData(
        name: nameController?.text ?? '',
        area: double.tryParse(areaController?.text ?? '0') ?? 0.0,
        latitude: latitudeController?.text ?? '',
        longitude: longitudeController?.text ?? '',
        create: false,
      );
      await model.update(updatedModel);

      showEditSuccessModal(context);
    } catch (e) {
      setError(e);
      AlertManager.showToast('Erro ao salvar!');
    } finally {
      setLoading(false);
    }
  }

  Future<List<ShareModel>> sharedUsers(
      BuildContext context, String? farmId) async {
    return _repository.getSharedUsers(farmId);
  }

  void removeSharedUser(BuildContext context, ShareModel model) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir o compartilhamento?',
        popScopePageRoute: RouteName.home,
        type: BaseModalType.danger,
        actionButtonTitle: 'Confirmar',
        actionCallback: () {
          _removeSharedUser(context, model);
        },
      ),
    );
  }

  void _removeSharedUser(BuildContext context, ShareModel model) async {
    await FirebaseFirestore.instance
        .collection('shares')
        .doc(model.ffRef?.id)
        .delete();
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Compartilhamento excluído com sucesso!',
        popScopePageRoute: RouteName.farms,
        actionCallback: () => context.pop(),
        showCancel: false,
      ),
    );
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const BaseAlertModal(
        title: 'Fazenda salva com sucesso!',
        description:
            "A sua fazenda foi salva com sucesso, e você pode encontrar"
            " todas as suas fazendas no menu “Minhas fazendas”.",
        popScopePageRoute: RouteName.home,
        showCancel: false,
      ),
    );
  }

  void showEditSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const BaseAlertModal(
        title: 'Fazenda editada com sucesso!',
        description:
            "A sua fazenda foi editada com sucesso, e você pode encontrar"
            " todas as suas fazendas no menu “Minhas fazendas”.",
        popScopePageRoute: RouteName.home,
        showCancel: false,
      ),
    );
  }
}
