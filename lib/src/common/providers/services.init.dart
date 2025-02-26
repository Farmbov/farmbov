import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/providers/firebase_services.dart';
import 'package:farmbov/src/common/providers/onesingal_service.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/app/flavors.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:url_strategy/url_strategy.dart';

/// Initialize services of the app including Firebase.
Future<void> initServices(MainAppEnvironment flavor) async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  FlutterNativeSplash.remove();

  // Run the preload page while initializing the app.
  //runApp(const MaterialApp(home: SplashPage()));

  // Preloads fonts to avoid visual swaping.
  // await AppFonts.pendingFonts([AppFonts.inter, AppFonts.interTextTheme]);

  // Initialize Firebase with the given flavor.
  await initFirebase(flavor);

  AppManager.instance
      .firebaseUserStream()
      .listen((user) => AppManager.instance.updateUser(user));

  // TODO: fazer envs como é feito no Pronto Mobile
  if (!AppManager.isDEV) {
    AppManager.configureAnalytics();
    OneSignalService.setUp();
  }

  setPathUrlStrategy();

  // Initialize services of the app in parallel.
  await Future.wait([
    // Initialize CodePush service
    // ShorebirdCodePushService().checkForUpdates(),
    // Init DeepLink Listener
    //DeeplinkService().init(),
    //Load Customer setting for the application
    //CustomerSettings().load()
  ]);
}
