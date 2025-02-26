import 'dart:ui';

import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:farmbov/src/app/config/firebase_options_dev.dart';
import 'package:farmbov/src/app/flavors.dart';

class DevEnvironment implements MainAppEnvironment {
  @override
  String get name => 'dev';

  @override
  Flavor get flavor => Flavor.dev;

  @override
  Color get flavorBannerColor => const Color(0xFF16396F);

  @override
  FirebaseOptions get firebaseOptions =>
      DefaultDevFirebaseOptions.currentPlatform;
}
