import 'package:flutter/material.dart';

class WidgetDefaultLoader extends StatelessWidget {
  final Widget? child;
  final bool loading;

  const WidgetDefaultLoader({
    super.key,
    this.child,
    this.loading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    return const SizedBox.shrink();
  }
}
