// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/models/firestore/user_model.dart';
import 'package:farmbov/src/domain/stores/auth_store.dart';
import 'package:farmbov/src/presenter/shared/pages/side_menu_mobile/side_menu_mobile_model.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SideMenuMobileStore extends MobXStore<SideMenuMobileModel> {
  SideMenuMobileStore() : super(const SideMenuMobileModel());

  init() {
    getUserInfo();
    getAppVersion();
  }

  Future<void> getUserInfo() async {
    try {
      setLoading(true);

      final user = AppManager.instance.currentUser;

      final userRecord = await UserModel.getDocumentOnce(
        UserModel.collection.doc(user.user?.uid),
      );

      update(
        state.copyWith(
          user: userRecord,
          fullName: userRecord.fullName,
          userDocument: userRecord.document,
          email: userRecord.email,
          phone: userRecord.phoneNumber,
          photoUrl: userRecord.photoUrl,
        ),
      );
    } catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  void signOut(BuildContext context) async {
    final authStore = AuthStore();
    await authStore.signOut();
    context.goNamed(RouteName.signin);
  }

  void getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    update(state.copyWith(appVersion: packageInfo.version));
  }
}
