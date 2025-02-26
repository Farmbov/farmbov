import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/router/route_name.dart';
import '../../../../common/themes/theme_constants.dart';
import '../../../../domain/extensions/backend.dart';
import '../../../../domain/models/firestore/lot_model.dart';
import '../../../../domain/services/domain/animal_data_service.dart';
import '../../../../domain/stores/common_base_store.dart';
import '../../../shared/components/ff_button.dart';
import '../../../shared/modals/base_alert_modal.dart';

class LotsAreaPageStore extends CommonBaseStore<List<LotModel>> {
  final animalService = AnimalDataService();
  final String areaId;

  LotsAreaPageStore({required this.areaId}) : super([]);

  @override
  void init() async {}

  @override
  void disposeStore() {
    // TODO: implement disposeStore
  }

  Stream<List<LotModel>> queryLotsForArea() {
    return queryLotModel(
      queryBuilder: (model) => model
          .where('area_id', isEqualTo: areaId)
          .where('active', isEqualTo: true),
    );
  }

  void showAnimals(BuildContext context, LotModel model) {
    context.go("${RouteName.lots}/visualizar", extra: {
      "model": model,
    });
  }

  Future<int?> getAnimalsCountByLot(String lotName) async {
    return await animalService.getAnimalsCountByLot(lotName);
  }

  void updateLoteModal(
    BuildContext context, {
    LotModel? model,
  }) {
    final id = model?.ffRef?.id;

    if (id == null) {
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
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir o lote?',
        popScopePageRoute: RouteName.home,
        type: BaseModalType.danger,
        actionWidgets: [
          FFButton(
            text: 'Excluir lote',
            onPressed: () async {
              try {
                await model?.ffRef?.update({"active": false});
                context.pop();
                showDialog(
                  context: context,
                  builder: (_) => BaseAlertModal(
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
