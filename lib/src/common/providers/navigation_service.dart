import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/shared/pages/global_navigation/widgets/global_loader.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NavigationService {
  static GlobalKey<NavigatorState> menuKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldState> mobileMenuKey = GlobalKey<ScaffoldState>();
  static GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
}

const kTransitionInfoKey = '__transition_info__';

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
    bool mounted = true,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: params,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: params,
              extra: extra,
            );
}

extension GoRouterExtensions on GoRouter {
  AppManager get appState => AppManager.instance;

  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();

  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

class AppRoute {
  const AppRoute({
    required this.path,
    required this.builder,
    this.name,
    this.requireAuth = true,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String? name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, GoRouterState) builder;
  final List<RouteBase> routes;

  GoRoute toRoute(AppManager appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return RouteName.signin;
          }

          return null;
        },
        pageBuilder: (context, state) {
          final child = appStateNotifier.loading
              ? const GlobalLoader()
              : builder(context, state);

          return ResponsiveBreakpoints.of(context).isMobile
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionsBuilder: PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: child,
                  ).transitionsBuilder,
                )
              : NoTransitionPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}
