import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';
import 'package:farmbov/src/common/router/route_name.dart';

class CreateAccountSuccessModal extends StatelessWidget {
  const CreateAccountSuccessModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAlertModal(
      title: 'Conta criada com sucesso!',
      description: 'Sua conta foi criada com sucesso, agora você '
          'já pode cadastrar e gerenciar seus animais.',
      actionButtonTitle: 'Entrar',
      popScopePageRoute: RouteName.signin,
      actionCallback: () => context.goNamed(RouteName.signin),
    );
  }
}
