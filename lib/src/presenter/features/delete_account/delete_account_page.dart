// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  Future<void> _contactSupport(BuildContext context) async {
    final url = Uri(
      scheme: 'mailto',
      path: 'farm.bov@gmail.com',
      queryParameters: {
        'subject': '[Suporte] Excluir minha conta',
      },
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro ao entrar em contato com o suporte. Tente novamente mais tarde.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluir conta'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                size: 80,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 20),
              const Text(
                'Deseja realmente excluir a conta e apagar todos os dados?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Wrap(
                children: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 20),
                  TextButton.icon(
                    onPressed: () => _contactSupport(context),
                    label: const Text('Entrar em contato com o suporte'),
                    icon: const Icon(Icons.email),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
