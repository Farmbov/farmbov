// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/models/vaccine_model.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

import '../../../../common/router/route_name.dart';
import '../../../../common/themes/theme_constants.dart';
import '../../../../domain/models/drug_administration_type.dart';
import '../../../shared/components/ff_button.dart';

part 'vaccines_configuration_page_store.g.dart';

class VaccinesConfigurationPageStore = _VaccinesConfigurationPageStoreBase
    with _$VaccinesConfigurationPageStore;

abstract class _VaccinesConfigurationPageStoreBase with Store {
  ObservableList<VaccineModel> vaccinesList = ObservableList<VaccineModel>();

  ObservableList<DrugAdministrationType> drugAdministrationTypes =
      ObservableList<DrugAdministrationType>();

  @observable
  bool isLoading = false;

  final currentFarm = AppManager.instance.currentUser.currentFarm;

  @action
  Future<void> fetchFarmVaccines() async {
    try {
      isLoading = true;
      List<VaccineModel> vaccines = await FirebaseFirestore.instance
          .collection('farms')
          .doc(currentFarm!.id)
          .collection('vaccines')
          .get()
          .then((vaccines) {
        return vaccines.docs
            .map(
              (vaccine) => VaccineModel.fromJson(
                vaccine.data(),
                vaccine.reference,
              ),
            )
            .toList();
      });

      vaccinesList.addAll(vaccines);
      isLoading = false;
    } catch (e) {
      AlertManager.showToast('Erro ao carregar vacinas');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> fetchDrugAdministrationTypes() async {
    try {
      isLoading = true;
      List<DrugAdministrationType> types = await FirebaseFirestore.instance
          .collection('farms')
          .doc(currentFarm!.id)
          .collection('drug_administration_types')
          .get()
          .then((types) {
        return types.docs
            .map(
              (type) =>
                  DrugAdministrationType.fromMap(type.data(), type.reference),
            )
            .toList();
      });
      drugAdministrationTypes.addAll(types);
      isLoading = false;
    } catch (e) {
      AlertManager.showToast('Erro ao carregar vias de administração');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> addVaccine(VaccineModel vaccineModel) async {
    try {
      isLoading = true;

      if (currentFarm?.name == null) {
        throw Exception('Usuário sem fazenda!');
      }

      final repeatedVaccine =
          vaccinesList.where((vaccine) => vaccine.name == vaccineModel.name);

      if (repeatedVaccine.isNotEmpty) {
        AlertManager.showToast(
            'Vacina já cadastrada, tente novamente com outro nome.');
        isLoading = false;
        return;
      }

      await FirebaseFirestore.instance
          .collection('farms')
          .doc(currentFarm?.id)
          .collection('vaccines')
          .add(vaccineModel.toJson());

      vaccinesList.add(vaccineModel);
    } catch (e) {
      if (currentFarm?.name == null) {
        AlertManager.showToast(
          'Crie uma fazenda antes de cadastrar vacinas',
        );
      } else {
        AlertManager.showToast(
            'Erro ao adicionar vacina, tente novamente mais tarde.');
      }
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updateVaccine(VaccineModel vaccineModel) async {
    try {
      isLoading = true;
      if (currentFarm?.name == null) {
        throw Exception('Usuário sem fazenda!');
      }

      final docReference = vaccineModel.ref;
      if (docReference == null) {
        throw Exception('Referência do documento é nula.');
      }

      final repeatedVaccine = vaccinesList.where((vaccine) =>
          vaccine.name == vaccineModel.name &&
          docReference != vaccineModel.ref);
      if (repeatedVaccine.isNotEmpty) {
        AlertManager.showToast(
            'Vacina já cadastrada, tente novamente com outro nome.');
        isLoading = false;
        return;
      }

      await docReference.update(vaccineModel.toJson());
      int index =
          vaccinesList.indexWhere((vaccine) => vaccine.ref == docReference);
      if (index != -1) {
        vaccinesList[index] = vaccineModel;
      } else {
        debugPrint('Referência não encontrada na lista de vacinas.');
      }
    } catch (e) {
      if (currentFarm?.name == null) {
        AlertManager.showToast('Crie uma fazenda antes de atualizar vacinas');
      } else {
        debugPrint(e.toString());
        AlertManager.showToast(
            'Erro ao atualizar vacina, tente novamente mais tarde.');
      }
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> deleteVaccine(
    BuildContext context, {
    required VaccineModel vaccineModel,
  }) async {
    isLoading = true;

    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir essa Vacina?',
        type: BaseModalType.danger,
        actionWidgets: [
          FFButton(
            text: 'Excluir Vacina',
            onPressed: () async {
              try {
                var documentReference = vaccineModel.ref;

                await documentReference?.delete();

                showDialog(
                  context: context,
                  builder: (_) => const BaseAlertModal(
                    popScopePageRoute: RouteName.vaccinesConfiguration,
                    showCancel: false,
                    title: 'Vacina excluída com sucesso!',
                  ),
                );

                vaccinesList.remove(vaccineModel);
              } catch (e) {
                AlertManager.showToast('Erro ao excluir vacina');
              } finally {
                isLoading = false;
              }
            },
            backgroundColor: AppColors.feedbackDanger,
            borderColor: AppColors.feedbackDanger,
            textColor: Colors.white,
          ),
          const SizedBox(height: 16),
          FFButton(
            text: 'Cancelar',
            onPressed: () => context.pop(),
            backgroundColor: Colors.transparent,
            borderColor: AppColors.feedbackDanger,
            textColor: AppColors.feedbackDanger,
            splashColor: AppColors.feedbackDanger.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Future<DrugAdministrationType> getAdmType(String drugAdmTypeId) async {
    final type = await FirebaseFirestore.instance
        .collection('farms')
        .doc(currentFarm?.id!)
        .collection('drug_administration_types')
        .doc(drugAdmTypeId)
        .get()
        .then((type) {
      return DrugAdministrationType.fromMap(type.data()!, type.reference);
    });
    return type;
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Vacina adicionada com sucesso!',
        actionCallback: () => context.pop(),
        showCancel: false,
      ),
    );
  }
}
