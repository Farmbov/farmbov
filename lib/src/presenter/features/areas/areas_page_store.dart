// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/domain/models/firestore/area_model.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/services/domain/animal_data_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/domain/stores/common_base_store.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

class AreasPageStore extends CommonBaseStore<List<AreaModel>> {
  final animalSevice = AnimalDataService();

  AreasPageStore() : super([]);

  @override
  void init() async {}

  @override
  void disposeStore() {
    // TODO: implement disposeStore
  }

  void updateAreaModal(
    BuildContext context, {
    AreaModel? model,
  }) {
    final id = model?.ffRef?.id;

    if (id == null) {
      context.go("${RouteName.areas}/novo");
    } else {
      context.go("${RouteName.areas}/$id", extra: {
        "model": model,
      });
    }
  }

  Future<int?> getAnimalsCountByLotArea(String lotName) async {
    return await animalSevice.getAnimalsCountByLotArea(lotName);
  }

  void deleteAreaModal(
    BuildContext context, {
    AreaModel? model,
  }) async {
    final areaAnimalsCounter =
        await animalSevice.getAnimalsCountByLotArea(model!.name!);
    final bool areaHasAnimal = areaAnimalsCounter! > 0;

    if (areaHasAnimal) {
      showDialog(
        context: context,
        builder: (_) => BaseAlertModal(
          title: 'Exclusão de área não permitida',
          description:
              'Esta área possui $areaAnimalsCounter animais associados e não pode ser excluída. Por favor, remova os animais desta área antes de tentar novamente.',
          popScopePageRoute: RouteName.areas,
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
      await showDialog(
        context: context,
        builder: (_) => BaseAlertModal(
          title: 'Tem certeza que deseja excluir a área ${model.name}?',
          actionButtonTitle: 'Confirmar',
          type: BaseModalType.danger,
          popScopePageRoute: RouteName.areas,
          actionWidgets: [
            FFButton(
              text: 'Excluir área',
              onPressed: () async {
                try {
                  await model.ffRef?.update({"active": false});
                  context.pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao excluir área'),
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
