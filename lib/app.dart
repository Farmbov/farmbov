import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:farmbov/src/common/helpers/profiler_extension.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/providers/services.init.dart';
import 'package:farmbov/src/presenter/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:farmbov/src/app/flavors.dart';
import 'package:provider/provider.dart';

Future<void> mainApp({required MainAppEnvironment environment}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Make status bar translucent.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Init services of the app and measure the time.
    await Profiler.measureAsync(
      name: 'mainApp.initServices',
      f: () async => initServices(environment),
    );

    final savedThemeMode = await AdaptiveTheme.getThemeMode();

    // Runs the main app module.
    runApp(
      ChangeNotifierProvider(
        create: (context) => AppManager.instance,
        child: MainApp(
          savedThemeMode: savedThemeMode,
          environment: environment,
        ),
      ),
    );
  }, (error, stack) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        context: ErrorDescription('runZonedGuarded - uncaught error'),
      ),
    );
  });
}
