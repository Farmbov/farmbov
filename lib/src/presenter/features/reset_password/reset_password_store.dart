// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/domain/stores/auth_store.dart';
import 'package:farmbov/src/common/router/route_name.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

class ResetPasswordStore extends MobXStore<bool> {
  ResetPasswordStore() : super(false);

  final authStore = AuthStore();

  final formKey = GlobalKey<FormState>();

  TextEditingController? emailController = TextEditingController();

  init() {
    emailController ??= TextEditingController();
  }

  dispose() {
    emailController?.dispose();
  }

  Future<void> send(BuildContext context) async {
    setLoading(true);

    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return setLoading(false);
    }

    await authStore.resetPassword(
      emailController!.text,
    );

    AlertManager.showToast('E-mail de recuperação enviado com sucesso!');

    setLoading(false);
    context.goNamed(RouteName.signin);
  }
}
