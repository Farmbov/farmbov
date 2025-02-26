// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/router/route_name.dart';

class PreloadPageStore extends MobXStore<bool> {
  PreloadPageStore() : super(false);

  void init(BuildContext context) async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    if (AppManager.instance.loggedIn) {
      context.goNamedAuth(RouteName.home);
    } else {
      context.goNamed(RouteName.welcome);
    }
    update(true);
    setLoading(false);
  }
}
