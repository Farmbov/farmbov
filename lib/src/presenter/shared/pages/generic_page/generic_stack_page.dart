import 'package:farmbov/src/common/helpers/context_extensions.dart';
import 'package:flutter/material.dart';

class GenericStackPage extends StatelessWidget {
  final Widget child;

  const GenericStackPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
       await  context.popSafely();
        return true;
      },
      child: child,
    );
  }

}
