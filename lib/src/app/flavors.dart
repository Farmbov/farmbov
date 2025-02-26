import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

abstract class MainAppEnvironment {
  String get name;

  Flavor get flavor;

  Color get flavorBannerColor;

  FirebaseOptions get firebaseOptions;
}

enum Flavor { prod, dev }

class FlavorManager {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.prod:
        return 'Farmbov';
      case Flavor.dev:
        return 'Farmbov Testes';
      default:
        return 'Farmbov';
    }
  }

  static Widget debugBanner({
    required Widget child,
    required MainAppEnvironment environment,
    bool show = false,
  }) =>
      show
          ? Banner(
              location: BannerLocation.topEnd,
              message: environment.name,
              color: environment.flavorBannerColor,
              textStyle: const TextStyle(
                fontSize: 12.0,
                letterSpacing: 1.0,
                color: Colors.white,
              ),
              textDirection: TextDirection.ltr,
              child: child,
            )
          : child;
}
