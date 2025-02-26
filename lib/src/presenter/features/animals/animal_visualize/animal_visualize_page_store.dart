// ignore_for_file: use_build_context_synchronously
import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/constants/animal_handling_types.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/animal_handling_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/domain/stores/common_base_store.dart';
import 'package:farmbov/src/presenter/features/animal_handlings/animal_handling_update/animal_handling_update_page.dart';
import 'package:farmbov/src/presenter/features/animal_handlings/animal_handling_update/animal_handling_update_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimalVisualizePageStore extends CommonBaseStore {
  AnimalVisualizePageStore() : super(null);

  void editManejoModal(
    BuildContext context, {
    AnimalModel? animal,
    AnimalHandlingTypes? type,
    AnimalHandlingModel? model,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return AnimalHandlingUpdatePage(
          store: AnimalHandlingUpdatePageStore(
            animal: animal,
            model: model,
            handlingType: type,
          ),
        );
      },
    );
  }

  void deleteManejoModal(
    BuildContext context,
    AnimalHandlingModel model,
  ) async {
    AnimalHandlingTypes? handlingType;

    if (model.handlingType == 'sanitario') {
      handlingType = AnimalHandlingTypes.sanitario;
    } else if (model.handlingType == 'pesagem') {
      handlingType = AnimalHandlingTypes.pesagem;
    } else {
      handlingType = AnimalHandlingTypes.reprodutivo;
    }

    //Ao deletar deve "devolver" a unidade de vacina em questão.
    if (handlingType == AnimalHandlingTypes.sanitario) {
      //Adapta para o nome está no formato que está salvo no firebase
      String? vaccine = model.vaccine;

      final vaccineName = capitalizeEachWord(vaccine!);

      final batchNumber = model.batchNumber;

      final vaccineRef = await FirebaseFirestore.instance
          .collection('farms')
          .doc(AppManager.instance.currentUser.currentFarm?.id)
          .collection('vaccines')
          .where('name', isEqualTo: vaccineName)
          .get();

      int currentQuantityOnBatch = 0;
      DocumentReference batchRef = await vaccineRef.docs.first.reference
          .collection('batches')
          .where('batch_number', isEqualTo: batchNumber)
          .get()
          .then((value) {
        var batch = value.docs.first;
        currentQuantityOnBatch = batch.data()['available_quantity'];
        return batch.reference;
      });

      await showDialog(
        context: context,
        builder: (_) => BaseAlertModal(
          title: 'Tem certeza que deseja excluir o manejo?',
          description:
              'Ao excluir esta aplicação, a quantidade de doses utilizadas será devolvida ao estoque do lote correspondente.',
          type: BaseModalType.danger,
          canPop: true,
          actionWidgets: [
            FFButton(
              text: 'Excluir manejo',
              onPressed: () async {
                try {
                  await model.ffRef?.delete();
                  //TODO verificar se terá vacinas que tomarão mais de uma dose
                  await batchRef.update(
                      {'available_quantity': currentQuantityOnBatch + 1});
                  context.pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao excluir manejo'),
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
              onPressed: () => GoRouter.of(context).pop(),
              backgroundColor: Colors.transparent,
              borderColor: AppColors.feedbackDanger,
              textColor: AppColors.feedbackDanger,
              splashColor: AppColors.feedbackDanger.withOpacity(0.1),
            ),
          ],
        ),
      );
    } else if (handlingType == AnimalHandlingTypes.pesagem ||
        handlingType == AnimalHandlingTypes.reprodutivo) {
      await showDialog(
        context: context,
        builder: (_) => BaseAlertModal(
          title: 'Tem certeza que deseja excluir o manejo?',
          type: BaseModalType.danger,
          canPop: true,
          actionWidgets: [
            FFButton(
              text: 'Excluir manejo',
              onPressed: () async {
                try {
                  await model.ffRef?.delete();
                  context.pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao excluir manejo'),
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
              onPressed: () => GoRouter.of(context).pop(),
              backgroundColor: Colors.transparent,
              borderColor: AppColors.feedbackDanger,
              textColor: AppColors.feedbackDanger,
              splashColor: AppColors.feedbackDanger.withOpacity(0.1),
            ),
          ],
        ),
      );
    } else {
      AlertManager.showToast(
          'Erro ao tentar deletar manejo. Tente novamente mais tarde!');
    }
  }
}

String capitalizeEachWord(String phrase) {
  return phrase
      .split(' ')
      .map((word) => word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '')
      .join(' ');
}
