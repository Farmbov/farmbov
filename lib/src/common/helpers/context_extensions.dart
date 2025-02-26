import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/shared/components/exit_app_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

extension GoRouterHelper on BuildContext {
  void goRoot() => GoRouter.of(this).go(RouteName.root);
  void goHome() => GoRouter.of(this).go(RouteName.home);

  Future<void> showExitConfirmationDialog() async {
    final exitConfirmed = await showDialog<bool>(
      context: this,
      builder: (context) => const ExitAppModal(),
    );

    if (exitConfirmed == true) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        ScaffoldMessenger.of(this).showSnackBar(
          const SnackBar(
            content: Text(
              'Use o botão Home para sair do app',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> popSafely() async {
    final currentPath =
        GoRouter.of(this).routeInformationProvider.value.uri.path;

    // Verifica se não pode realizar o pop
    if (!canPop()) {
      // caso não possa e a rota seja a home exibe dialog de confirmação de saída
      if (currentPath == RouteName.home) {
        await showExitConfirmationDialog();
      } else {
        // caso não possa e não é home significa que é uma das outras branchs
        final shell = StatefulNavigationShell.of(this);
        shell.goBranch(0);
      }
    } else {
      //caso tenha itens na stack de navegação, realiza o pop
      pop();
    }
  }
}
