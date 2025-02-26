// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:farmbov/src/domain/services/domain/vaccine_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/constants/animal_sex.dart';
import 'package:farmbov/src/domain/models/firestore/vaccine_model.dart';
import 'package:farmbov/src/domain/stores/common_base_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

class VaccinesPageStore extends CommonBaseStore<List<VaccineModel>> {
  VaccinesPageStore() : super(null);

  final formKey = GlobalKey<FormState>();

  TextEditingController? searchController;
  Timer? _debounceTimer;
  bool searchingTerm = false;

  List<String> selectedSexOptions =
      List<String>.from(animalSexList, growable: true);
  List<String> selectedLoteOptions = List<String>.empty(growable: true);

  final VaccineService vaccineService = VaccineService();

  @override
  init() {
    searchController = TextEditingController();
  }

  dispose() {
    searchController?.dispose();
    _debounceTimer?.cancel();
  }

  void updateVacinaModal(
    BuildContext context, {
    VaccineModel? model,
  }) {
    final id = model?.ffRef?.id;

    if (id == null) {
      context.go("${RouteName.vaccines}/novo");
    } else {
      context.go("${RouteName.vaccines}/$id", extra: {
        "model": model,
      });
    }
  }

  void deleteVacinaModal(
    BuildContext context, {
    VaccineModel? model,
  }) async {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir a vacina?',
        type: BaseModalType.danger,
        actionWidgets: [
          // TODO: move to DS
          FFButton(
            text: 'Excluir vacina',
            onPressed: () async {
              try {
                await model?.ffRef?.update({"active": false});
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.pop();
                });
                showDialog(
                  context: context,
                  builder: (_) => BaseAlertModal(
                    title: 'Vacina excluída com sucesso!',
                    popScopePageRoute: RouteName.vaccines,
                    actionCallback: () {
                      context.pop();
                    },
                    showCancel: false,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro ao excluir vacina'),
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
