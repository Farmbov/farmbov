import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:farmbov/src/app/flavors.dart';
import 'package:farmbov/src/common/router/router_config.dart';

import 'package:flash/flash_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/themes/light_theme.dart';

class MainApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final MainAppEnvironment environment;

  const MainApp({
    super.key,
    required this.environment,
    this.savedThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: LightTheme.of(context),
      dark: LightTheme.of(context),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => ResponsiveSizer(
        builder: (context, orientation, screenType) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pt', 'BR'),
          title: 'Farmbov',
          theme: theme,
          darkTheme: theme,
          scaffoldMessengerKey: NavigationService.scaffoldKey,
          routerConfig: AppRouterConfig.createRouter(AppManager.instance),
          builder: (context, child) => FlavorManager.debugBanner(
            environment: environment,
            show: kDebugMode,
            child: Toast(
              navigatorKey: NavigationService.rootNavigatorKey,
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) => ResponsiveBreakpoints.builder(
                      child: Consumer<AppManager>(
                        builder: (_, __, ___) => child!,
                      ),
                      breakpoints: [
                        const Breakpoint(start: 0, end: 800, name: MOBILE),
                        const Breakpoint(
                            start: 801, end: double.infinity, name: DESKTOP),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
