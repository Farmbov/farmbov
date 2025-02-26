import 'package:farmbov/src/common/helpers/context_extensions.dart';
import 'package:flutter/material.dart';

class CommonErrorPage extends StatelessWidget {
  const CommonErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ops! Ocorreu um erro'),
      content: const Text('Página não encontrada.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => context.goRoot(),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
