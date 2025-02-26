import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';

class AlertManager {
  static void showToast(
    String message, {
    BuildContext? context,
    int duration = 2,
  }) {
    final finalContext =
        context ?? NavigationService.rootNavigatorKey.currentContext!;
    finalContext.showToast(
      Text(message),
      shape: const StadiumBorder(),
      queue: false,
      alignment: Alignment.topRight,
    );
  }
}
