import 'package:flutter/material.dart';

import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class AnimalsRegisterModal extends StatelessWidget {
  const AnimalsRegisterModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseModalBottomSheet(
      title: 'Cadastrar meus animais',
      children: [
        const SizedBox(height: 60),
        Text(
          'Como você deseja cadastrar seus animais?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FFButton(
          text: 'Cadastrar em lote',
          onPressed: () => context.push(RouteName.animalsImport),
        ),
        const SizedBox(height: 16),
        FFButton(
          text: 'Cadastrar unidade',
          type: FFButtonType.outlined,
          onPressed: () {
            context.pop();
            context.push(RouteName.animalCreate);
          },
        ),
      ],
    );
  }
}
