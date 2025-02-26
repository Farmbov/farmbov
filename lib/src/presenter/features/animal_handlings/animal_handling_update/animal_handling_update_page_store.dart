// ignore_for_file: use_build_context_synchronously

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

import '../../../../common/providers/alert_manager.dart';
import '../../../../common/providers/app_manager.dart';
import '../../../../domain/constants/animal_handling_types.dart';
import '../../../../domain/extensions/backend.dart';
import '../../../../domain/models/firestore/animal_handling_model.dart';
import '../../../../domain/models/firestore/animal_model.dart';
import '../../../../domain/models/vaccine_batch_model.dart';
import '../../../../domain/models/vaccine_model.dart';
import '../../../../domain/repositories/animal_repository.dart';
import '../../../shared/modals/base_alert_modal.dart';

part 'animal_handling_update_page_store.g.dart';

class AnimalHandlingUpdatePageStore = _AnimalHandlingUpdatePageStoreBase
    with _$AnimalHandlingUpdatePageStore;

abstract class _AnimalHandlingUpdatePageStoreBase with Store {
  final AnimalRepository animalRepository = AnimalRepositoryImpl();

  _AnimalHandlingUpdatePageStoreBase(
      // ignore: unused_element
      {this.animal,
      this.model,
      this.handlingType}) {
    _init();
  }
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Observables

  @observable
  bool isLoading = false;

  @observable
  AnimalHandlingModel? model;

  @observable
  AnimalModel? animal;

  @observable
  AnimalModel? selectedMaleAnimal;

  @observable
  AnimalHandlingTypes? handlingType;

  @observable
  DateTime? weightHandlingDate;

  @observable
  DateTime? healthHandlingDate;

  @observable
  DateTime? reproductionHandlingDate;

  @observable
  DateTime? pregnantLikelyDate;

  @observable
  String? vaccine;

  @observable
  bool isPregnant = false;

  @observable
  bool isHandlingTypeSelected = false;

  @observable
  ObservableList<AnimalModel> activeAnimals = ObservableList<AnimalModel>();

  @observable
  TextEditingController weightController = MoneyMaskedTextController();

  @observable
  bool isLastStep = false;

  @action
  void updateIsLastStep(bool newState) {
    isLastStep = newState;
  }

  @computed
  bool get formIsValid {
    switch (handlingType) {
      case AnimalHandlingTypes.pesagem:
        return animal != null && weightController.text.isNotEmpty;
      case AnimalHandlingTypes.sanitario:
        return animal != null && vaccine != null;
      case AnimalHandlingTypes.reprodutivo:
        return animal != null &&
            selectedMaleAnimal != null &&
            (!isPregnant || (pregnantLikelyDate != null));
      default:
        return false;
    }
  }

  // Actions
  @action
  void updateHandlingType(AnimalHandlingTypes? type) {
    handlingType = type;
    isHandlingTypeSelected = type != null;
  }

  @action
  void updateModel(AnimalHandlingModel? newModel) {
    model = newModel;
  }

  @action
  void updateSelectedAnimal(AnimalModel? newAnimal) {
    animal = newAnimal;
  }

  @action
  void updateSelectedMaleAnimal(AnimalModel? maleAnimal) {
    selectedMaleAnimal = maleAnimal;
  }

  @action
  void updateWeightHandlingDate(DateTime? date) {
    weightHandlingDate = date;
  }

  @action
  void updateHealthHandlingDate(DateTime? date) {
    healthHandlingDate = date;
  }

  @action
  void updateReproductionHandlingDate(DateTime? date) {
    reproductionHandlingDate = date;
  }

  @action
  void updatePregnancyStatus(bool pregnant) {
    isPregnant = pregnant;
  }

  @action
  void updatePregnantLikelyDate(DateTime? date) {
    pregnantLikelyDate = date;
  }

  @action
  void updateVaccine(String? newVaccine) {
    vaccine = newVaccine;
  }

  @action
  Future<void> _init() async {
    if (model != null) {
      weightController.text = model?.weight ?? '';
      weightHandlingDate = model?.handlingDate;
      healthHandlingDate = model?.handlingDate;
      reproductionHandlingDate = model?.handlingDate;
      vaccine = model?.vaccine;
      isPregnant = model?.isPregnant ?? false;
      if (model?.maleTagNumber != null) {
        var gettedMale = await FirebaseFirestore.instance
            .collection('farms')
            .doc(AppManager.instance.currentUser.currentFarm?.id)
            .collection('animals')
            .where('tag_number', isEqualTo: model!.maleTagNumber!)
            .where('active', isEqualTo: true)
            .get();

        selectedMaleAnimal =
            AnimalModel.getDocumentFromData(gettedMale.docs.first.data());
      }

      pregnantLikelyDate = model?.pregnantDate;
    }
    await loadActiveAnimals();
  }

  @action
  Future<void> loadActiveAnimals() async {
    try {
      final animals = await animalRepository.listAnimals();
      activeAnimals.clear();
      activeAnimals.addAll(animals);
    } catch (e) {
      activeAnimals.clear();
    }
  }

  Future<void> _saveOrUpdateHandlingData(Map<String, dynamic> data) async {
    if (model == null) {
      await AnimalHandlingModel.collection.doc().set(data);
    } else {
      await model!.reference.update(data);
    }
  }

  @action
  Future<void> finish(BuildContext context) async {
    isLoading = true;
    if (!formIsValid) {
      showErrorModal(context);
      isLoading = false;
      return;
    }

    try {
      switch (handlingType) {
        case AnimalHandlingTypes.pesagem:
          await finishPesagem(context);
          break;
        case AnimalHandlingTypes.sanitario:
          await finishSanitario(context);
          break;
        case AnimalHandlingTypes.reprodutivo:
          await finishReprodutivo(context);
          break;
        default:
          throw Exception("Tipo de manejo não definido.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erro ao registrar manejo. Tente novamente.')),
      );
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> finishPesagem(BuildContext context) async {
    final manejoCreateData = createManejoRecordData(
      handlingType: AnimalHandlingTypes.pesagem.name,
      tagNumber: animal?.tagNumber,
      handlingDate: weightHandlingDate ?? getCurrentTimestamp,
      weight: weightController.text,
    );

    if (model == null) {
      await AnimalHandlingModel.collection.doc().set(manejoCreateData);
    } else {
      await model!.reference.update(manejoCreateData);
    }
    //Atualiza o novo peso do animal
    await animal?.reference.update({
      'weight': double.tryParse(
          weightController.text.replaceAll('.', '').replaceAll(',', '.')),
      'weighing_date': weightHandlingDate ?? getCurrentTimestamp
    });
    showSuccessModal(context);
  }

  @action
  Future<void> finishReprodutivo(BuildContext context) async {
    Map<String, dynamic> manejoCreateData = createManejoRecordData(
      handlingType: AnimalHandlingTypes.reprodutivo.name,
      tagNumber: animal?.tagNumber,
      handlingDate: reproductionHandlingDate ?? getCurrentTimestamp,
      isPregnant: isPregnant,
      pregnantDate: pregnantLikelyDate,
    );

    manejoCreateData.addAll(
        <String, dynamic>{'male_tag_number': selectedMaleAnimal?.tagNumber});
    if (model == null) {
      await AnimalHandlingModel.collection.doc().set(manejoCreateData);
    } else {
      await model!.reference.update(manejoCreateData);
    }

    showSuccessModal(context);
  }

  //TODO: É válido uma refatoração pra simplicar tal código, inclusive em aplicação em lote. APlicar o DRY
  //TODO: Ao editar aplicação de vacina está descontando uma dose de vacina e criando no manejo sanitário, caso a vacina ñ tenha sido alterada não devia criar novo
  // Os campos opcionais foram adicionados para não repetir a lógica de aplicação de vacina na tela do animal
  @action
  Future<void> finishSanitario(
    BuildContext context, {
    VaccineModel? selectedVaccine,
    DateTime? handlingDate,
    AnimalModel? selectedAnimal,
  }) async {
    try {
      // Variáveis de controle
      QuerySnapshot<Map<String, dynamic>>? vaccineBatchesSnapshot;
      List<VaccineBatchModel> availableBatches = [];
      int totalAvailableDoses = 0;

      // Obter lotes disponíveis
      if (selectedVaccine == null) {
        // Busca a vacina e seus lotes
        final vaccineSnapshot = await FirebaseFirestore.instance
            .collection('farms')
            .doc(AppManager.instance.currentUser.currentFarm?.id)
            .collection('vaccines')
            .where('name', isEqualTo: vaccine?.toLowerCase())
            .get();

        if (vaccineSnapshot.docs.isEmpty) {
          throw Exception("Vacina não encontrada.");
        }

        vaccineBatchesSnapshot = await vaccineSnapshot.docs.first.reference
            .collection('batches')
            .where('available_quantity', isGreaterThan: 0)
            .where('expiration_date', isGreaterThanOrEqualTo: DateTime.now())
            .orderBy('expiration_date')
            .get();
      } else {
        vaccineBatchesSnapshot = await selectedVaccine.ref
            ?.collection('batches')
            .where('available_quantity', isGreaterThan: 0)
            .where('expiration_date', isGreaterThanOrEqualTo: DateTime.now())
            .orderBy('expiration_date')
            .get();
      }

      // Processar lotes disponíveis
      if (vaccineBatchesSnapshot == null ||
          vaccineBatchesSnapshot.docs.isEmpty) {
        AlertManager.showToast('Não há lotes disponíveis para essa vacina.');
        isLoading = false;
        return;
      }

      for (var batch in vaccineBatchesSnapshot.docs) {
        final batchData = batch.data();
        final availableQuantity = batchData['available_quantity'] as int;

        totalAvailableDoses += availableQuantity;
        availableBatches
            .add(VaccineBatchModel.fromJson(batchData, batch.reference));
      }

      if (totalAvailableDoses < 1) {
        AlertManager.showToast(
            'Não há doses suficientes dessa vacina para aplicar neste animal.');
        isLoading = false;
        return;
      }

      // Reduzir doses disponíveis
      int dosesToReduce = 1;
      String? assignedBatchNumber;

      for (var batch in availableBatches) {
        if (dosesToReduce <= 0) break;

        if (batch.availableQuantity > 0) {
          if (batch.availableQuantity >= dosesToReduce) {
            batch.availableQuantity -= dosesToReduce;
            assignedBatchNumber = batch.batchNumber; // Lote atribuído
            dosesToReduce = 0;
          } else {
            dosesToReduce -= batch.availableQuantity;
            assignedBatchNumber = batch.batchNumber; // Lote atribuído
            batch.availableQuantity = 0;
          }

          // Atualizar lote no Firestore
          await batch.ref
              ?.update({'available_quantity': batch.availableQuantity});
        }
      }

      if (assignedBatchNumber == null) {
        AlertManager.showToast('Erro ao atribuir o lote da vacina.');
        return;
      }

      // Criar ou atualizar o manejo
      final manejoCreateData = createManejoRecordData(
        handlingType: AnimalHandlingTypes.sanitario.name,
        tagNumber: animal?.tagNumber ?? selectedAnimal?.tagNumber,
        handlingDate:
            handlingDate ?? (healthHandlingDate ?? getCurrentTimestamp),
        vaccine: selectedVaccine?.name?.toLowerCase() ?? vaccine?.toLowerCase(),
      )..['batch_number'] = assignedBatchNumber;

      if (model == null) {
        await AnimalHandlingModel.collection.doc().set(manejoCreateData);
      } else {
        await model!.reference.update(manejoCreateData);
      }

      isLoading = false;
      // Mostrar modal de sucesso
      showSuccessModal(context);
    } catch (e) {
      AlertManager.showToast('Ocorreu um erro ao finalizar o manejo.');
      isLoading = false;
    }
  }

  // Modais
  void showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        type: BaseModalType.success,
        title: 'Manejo registrado com sucesso!',
        description: "O manejo do seu animal foi registrado com sucesso,"
            " você pode conferir na área do seu animal.",
        actionButtonTitle: "Entendi",
        actionCallback: () {
          context.pop();
          context.pop();
        },
        showCancel: false,
        canPop: true,
      ),
    );
  }

  void showErrorModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Formulário Incompleto!'),
        content:
            const Text('Por favor, preencha todos os campos obrigatórios.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void dispose() {
    weightController.dispose();
  }
}
