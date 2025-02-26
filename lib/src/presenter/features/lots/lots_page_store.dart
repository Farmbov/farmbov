// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/services/domain/animal_data_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/domain/stores/common_base_store.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

class LotsPageStore extends CommonBaseStore<List<LotModel>> {
  final animalSevice = AnimalDataService();

  LotsPageStore() : super([]);

  @override
  void init() async {}

  @override
  void disposeStore() {
    // TODO: implement disposeStore
  }

  void showAnimals(BuildContext context, LotModel model) {
    context.go("${RouteName.lots}/visualizar", extra: {
      "model": model,
    });
  }

  Future<int?> getAnimalsCountByLot(String lotName) async {
    return await animalSevice.getAnimalsCountByLot(lotName);
  }

  void updateLoteModal(
    BuildContext context, {
    LotModel? model,
  }) {
    final id = model?.ffRef?.id;
    //Gabira
    final name = model?.name;

    if (id == null && name == null) {
      context.go("${RouteName.lots}/novo");
    } else {
      context.go("${RouteName.lots}/$id", extra: {
        "model": model,
      });
    }
  }

  void deleteLoteModal(
    BuildContext context, {
    LotModel? model,
  }) async {
    final lotAnimalsCounter =
        await animalSevice.getAnimalsCountByLot(model!.name!);
    final bool lotHasAnimal = lotAnimalsCounter! > 0;

    if (lotHasAnimal) {
      showDialog(
        context: context,
        builder: (_) => BaseAlertModal(
          title: 'Exclusão de lote não permitida',
          description:
              'Este lote possui $lotAnimalsCounter animais associados e não pode ser excluído. Por favor, remova os animais deste lote antes de tentar novamente.',
          popScopePageRoute: RouteName.lots,
          type: BaseModalType.warning,
          actionWidgets: [
            FFButton(
              text: 'Ok',
              onPressed: () => context.pop(),
              backgroundColor: AppColors.primaryGreen,
              textColor: Colors.white,
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => BaseAlertModal(
          title: 'Tem certeza que deseja excluir o lote?',
          popScopePageRoute: RouteName.lots,
          type: BaseModalType.danger,
          actionWidgets: [
            // TODO: move to DS
            FFButton(
              text: 'Excluir lote',
              onPressed: () async {
                try {
                  await model.ffRef?.delete();

                  showDialog(
                    context: context,
                    builder: (_) => BaseAlertModal(
                      showCancel: false,
                      title: 'Lote excluído com sucesso!',
                      popScopePageRoute: RouteName.lots,
                      actionCallback: () => context.pop(),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao excluir lote'),
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
}
