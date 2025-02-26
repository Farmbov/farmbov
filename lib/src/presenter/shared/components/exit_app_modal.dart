import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExitAppModal extends StatelessWidget {
  const ExitAppModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sair do app'),
      content: const Text('Deseja realmente sair do aplicativo?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => GoRouter.of(context).pop(false),
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () => GoRouter.of(context).pop(true),
          child: const Text('Sim'),
        ),
      ],
    );
  }
}
