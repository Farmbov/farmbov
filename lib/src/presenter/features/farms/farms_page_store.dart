// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/farm_model.dart';
import 'package:farmbov/src/domain/repositories/farm_repository.dart';
import 'package:farmbov/src/domain/usecases/share_farm_usecase.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/domain/stores/common_base_store.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';
import 'package:provider/provider.dart';

class FarmsPageStore extends CommonBaseStore<List<FarmModel>> {
  FarmsPageStore() : super([]);

  final FarmRepository _repository = FarmRepositoryImpl();

  final TextEditingController _documentOrEmailController =
      TextEditingController();

  @override
  void init() async {}

  @override
  void disposeStore() {
    _documentOrEmailController.dispose();
  }

  Future<List<FarmModel>> getFarms() {
    return _repository
        .getSharedFarmsToUser(FirebaseAuth.instance.currentUser?.uid ?? '');
  }

  void _shareFarm(BuildContext context, String farmId) async {
    try {
      if (_documentOrEmailController.text.isEmpty) {
        throw Exception('Informe o CPF ou e-mail do usuário');
      }

      final sharedFarm = await ShareFarmUseCase().call(
        farmId,
        _documentOrEmailController.text,
      );

      if (sharedFarm == null) {
        throw Exception('Erro ao compartilhar fazenda');
      }

      showDialog(
        context: context,
        builder: (_) => BaseAlertModal(
          title: 'Fazenda compartilhada com sucesso!',
          popScopePageRoute: RouteName.farms,
          canPop: true,
          actionCallback: () {
            context.pop();
          },
          showCancel: false,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao compartilhar fazenda'),
        ),
      );
    }
  }

  void sharedUsers(BuildContext context, FarmModel model) {
    final id = model.ffRef?.id;
    context.go("${RouteName.farms}/$id/compartilhados", extra: {
      "model": model,
    });
  }

  void shareFarm(BuildContext context, FarmModel model) {
    final currentUser =
        Provider.of<AppManager>(context, listen: false).currentUser;

    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        canPop: true,
        popScopePageRoute: RouteName.farms,
        title: 'Compartilhar fazenda',
        description:
            'Digite o e-mail do usuário que deseja compartilhar a fazenda.',
        type: BaseModalType.warning,
        content: FFInput(
          labelText: 'E-mail',
          controller: _documentOrEmailController,
        ),
        actionCallback: () async {
          final emailValidator = EmailValidator(errorText: 'Email not valid');

          if (!emailValidator.isValid(_documentOrEmailController.text)) {
            showDialog(
                context: context,
                builder: (contex) => AlertDialog(
                      title: Text(
                        'Email inválido!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              color: AppColors.primaryGreen,
                            ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => contex.pop(),
                            child: const Text('Entendi'))
                      ],
                    ));
            return;
          } else if (_documentOrEmailController.text ==
              currentUser.userDetails?.email) {
            showDialog(
                context: context,
                builder: (contex) => AlertDialog(
                      title: Text(
                        'Não é possível compartilhar fazenda com você mesmo',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              color: AppColors.primaryGreen,
                            ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => contex.pop(),
                            child: const Text('Entendi'))
                      ],
                    ));
          } else {
            final countShares = await FirebaseFirestore.instance
                .collection('shares')
                .where('document_or_email',
                    isEqualTo: _documentOrEmailController.text)
                .where('farm_id', isEqualTo: model.ffRef?.id)
                .count()
                .get();

            if (countShares.count != null) {
              final farmAlreadySharedWithUser = countShares.count! >= 1;

              if (!farmAlreadySharedWithUser) {
                _shareFarm(context, model.ffRef!.id);
              } else {
                showDialog(
                    context: context,
                    builder: (contex) => AlertDialog(
                          title: Text(
                            'Esta fazenda já está compartilhada com o usuário',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 18,
                                      color: AppColors.primaryGreen,
                                    ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => contex.pop(),
                                child: const Text('Entendi'))
                          ],
                        ));
              }
            }
          }
        },
        cancelCallback: () => context.pop(),
        actionButtonIcon: const Icon(Icons.share),
        actionButtonTitle: 'Compartilhar',
      ),
    );
  }

  void updateFarmModal(
    BuildContext context, {
    FarmModel? model,
  }) {
    final id = model?.ffRef?.id;

    if (id == null) {
      context.go("${RouteName.farms}/novo");
    } else {
      context.go("${RouteName.farms}/$id", extra: {
        "model": model,
      });
    }
  }

  void _deleteFarm(BuildContext context, FarmModel model) async {
    await model.ffRef?.update({"active": false});
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Fazenda excluído com sucesso!',
        popScopePageRoute: RouteName.farms,
        actionCallback: () => context.pop(),
      ),
    );
  }

  void deleteFarmModal(
    BuildContext context, {
    FarmModel? model,
  }) async {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir a fazenda?',
        popScopePageRoute: RouteName.home,
        type: BaseModalType.danger,
        actionButtonTitle: 'Excluir fazenda',
        actionCallback: () => _deleteFarm(context, model!),
      ),
    );
  }
}
