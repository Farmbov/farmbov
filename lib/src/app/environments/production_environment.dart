import 'dart:ui';

import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:farmbov/src/app/config/firebase_options.dart';
import 'package:farmbov/src/app/flavors.dart';

class ProductionEnvironment implements MainAppEnvironment {
  @override
  String get name => 'prod';

  @override
  Flavor get flavor => Flavor.prod;

  @override
  Color get flavorBannerColor => const Color(0xFF475467);

  @override
  FirebaseOptions get firebaseOptions =>
      DefaultProductionFirebaseOptions.currentPlatform;
}
