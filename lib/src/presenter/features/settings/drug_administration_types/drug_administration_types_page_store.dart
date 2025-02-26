// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/drug_administration_type.dart';
import 'package:farmbov/src/domain/repositories/drug_adminstration_types_repository.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/stores/common_base_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DrugAdministrationTypesPageStore
    extends CommonBaseStore<List<DrugAdministrationType>> {
  DrugAdministrationTypesPageStore() : super([]);

  final typeController = TextEditingController();

  void addType(BuildContext context) async {
    final currentFarm =
        Provider.of<AppManager>(context, listen: false).currentUser.currentFarm;

    try {
      setLoading(true);

      if (currentFarm?.name == null) {
        throw Exception('Usuário sem fazenda!');
      }
      if (typeController.text.isEmpty) {
        throw Exception('Insira uma via de administração');
      }

      final repeatedType = (await getDrugAdministrationTypes(context))
          .where((type) => type.name == typeController.text);

      if (repeatedType.isNotEmpty) {
        AlertManager.showToast(
            'Via de Administração já cadastrado, tente novamente com outro nome.');
        return setLoading(false);
      }

      final typeData = {'type': typeController.text, 'is_active': true};

      await FirebaseFirestore.instance
          .collection('farms')
          .doc(currentFarm?.id)
          .collection('drug_administration_types')
          .add(typeData);

      showInsertSuccessModal(context);

      update([], force: true);
    } catch (e) {
      if (currentFarm?.name == null) {
        AlertManager.showToast(
          'Crie uma fazenda antes de cadastrar motivos de baixa!',
        );
      } else {
        AlertManager.showToast(
            'Erro ao adicionar via de administração, tente novamente mais tarde.');
      }
    } finally {
      setLoading(false);
    }
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Via de Administração adicionada com sucesso!',
        actionCallback: () => context.pop(),
        showCancel: false,
      ),
    );
  }

  void deleteDrugAdmType(
    BuildContext context, {
    DrugAdministrationType? model,
  }) async {
    final currentFarm =
        Provider.of<AppManager>(context, listen: false).currentUser.currentFarm;

    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir essa via de administração?',
        type: BaseModalType.danger,
        actionWidgets: [
          FFButton(
            text: 'Excluir Via',
            onPressed: () async {
              try {
                var ref = model?.ref;

                await ref?.delete();

                showDialog(
                  context: context,
                  builder: (_) => BaseAlertModal(
                    showCancel: false,
                    title: 'Via de administração excluída com sucesso!',
                    popScopePageRoute: RouteName.animalBreeds,
                    actionCallback: () => context.pop(),
                  ),
                );
              } catch (e) {
                if (currentFarm?.name == null) {
                  AlertManager.showToast(
                    'Crie uma fazenda antes de cadastrar vias de administração!',
                  );
                } else if (typeController.text.isEmpty) {
                  AlertManager.showToast(
                    'Insira o nome de via de administração',
                  );
                } else {
                  AlertManager.showToast(
                      'Erro ao adicionar via de administração, tente novamente mais tarde.');
                }
              } finally {
                setLoading(false);
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
}
