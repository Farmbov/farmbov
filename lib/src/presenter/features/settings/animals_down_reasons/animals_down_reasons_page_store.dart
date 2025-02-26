// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/animal_down_reason_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_breed_model.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/stores/common_base_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/animal_down_reasons_repository.dart';

class AnimalsDownReasonsPageStore
    extends CommonBaseStore<List<AnimalBreedModel>> {
  AnimalsDownReasonsPageStore() : super([]);

  final reasonController = TextEditingController();

  void addReason(BuildContext context) async {
    final currentFarm =
        Provider.of<AppManager>(context, listen: false).currentUser.currentFarm;
    try {
      setLoading(true);

      if (currentFarm?.name == null) {
        throw Exception('Usuário sem fazenda!');
      }

      if (reasonController.text.isEmpty) {
        throw Exception('Insira um motivo');
      }

      final repeatedReason = (await getAnimalDownReasons(context))
          .where((reason) => reason.name == reasonController.text);

      if (repeatedReason.isNotEmpty) {
        AlertManager.showToast(
            'Motivo de baixa já cadastrado, tente novamente com outro nome.');
        return setLoading(false);
      }

      final reasonData = {'reason': reasonController.text, 'is_active': true};

      await FirebaseFirestore.instance
          .collection('farms')
          .doc(currentFarm?.id)
          .collection('animal_down_reasons')
          .add(reasonData);

      showInsertSuccessModal(context);

      update([], force: true);
    } catch (e) {
      if (currentFarm?.name == null) {
        AlertManager.showToast(
          'Crie uma fazenda antes de cadastrar motivos de baixa!',
        );
      } else if (reasonController.text.isEmpty) {
        AlertManager.showToast(
          'Insira o nome do motivo de baixa',
        );
      } else {
        AlertManager.showToast(
            'Erro ao adicionar motivo de baixa, tente novamente mais tarde.');
      }
    } finally {
      setLoading(false);
    }
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Motivo adicionado com sucesso!',
        actionCallback: () => context.pop(),
        showCancel: false,
      ),
    );
  }

  void deleteReason(
    BuildContext context, {
    AnimalDownReasonModel? model,
  }) async {
    final currentFarm =
        Provider.of<AppManager>(context, listen: false).currentUser.currentFarm;

    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir esse motivo de baixa?',
        type: BaseModalType.danger,
        actionWidgets: [
          FFButton(
            text: 'Excluir Motivo',
            onPressed: () async {
              try {
                var ref = model?.ref;

                await FirebaseFirestore.instance
                    .collection('farms')
                    .doc(currentFarm?.id)
                    .collection('animal_down_reasons')
                    .doc(ref)
                    .delete();

                showDialog(
                  context: context,
                  builder: (_) => BaseAlertModal(
                    title: 'Motivo de baixa excluído com sucesso!',
                    actionCallback: () => context.pop(),
                    showCancel: false,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro ao excluir motivo de baixa'),
                  ),
                );
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
