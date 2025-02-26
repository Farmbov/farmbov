import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'package:farmbov/src/app/flavors.dart';

/// Initialize Firebase with the given [environment].
Future<void> initFirebase(MainAppEnvironment environment) async {
  try {
    await Firebase.initializeApp(
      name: environment.name,
      options: environment.firebaseOptions,
    );

    if (!kDebugMode) {
      // Pass all uncaught "fatal" errors from the framework to Crashlytics
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    // Initialize Firebase Remote Config
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    FirebaseRemoteConfig.instance.onConfigUpdated.listen(
          (event) async => FirebaseRemoteConfig.instance.activate(),
    );

    // Request permission for push notifications
    FirebaseMessaging.instance.requestPermission();

    Logger().d('Firebase initialized');
  } catch (e, s) {
    Logger().e('Error initializing Firebase', error: e, stackTrace: s);
  }
}
