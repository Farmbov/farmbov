import 'package:farmbov/src/presenter/shared/components/ff_circular_loader.dart';

import 'package:flutter/material.dart';

class GlobalLoader extends StatelessWidget {
  const GlobalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FFCircularLoader(),
    );
  }
}
