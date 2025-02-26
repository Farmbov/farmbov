// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/stores/auth_store.dart';
import 'package:farmbov/src/common/router/route_name.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/presenter/features/sign_in/sign_in_page_model.dart';
import 'package:flutter/material.dart';

import 'package:mobx_triple/mobx_triple.dart';

class SignInPageStore extends MobXStore<SignInPageModel> {
  SignInPageStore() : super(const SignInPageModel());

  final authStore = AuthStore();

  final formKey = GlobalKey<FormState>();

  TextEditingController emailAddressLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();

  dispose() {
    emailAddressLoginController.dispose();
    passwordLoginController.dispose();
  }

  Future<void> login(BuildContext context) async {
    setLoading(true);

    try {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return setLoading(false);
      }

      final user = await authStore.signIn(
        emailAddressLoginController.text,
        passwordLoginController.text,
      );

      if (user == null) {
        throw Exception('Invalid username or password');
      } else {
        _encryptPassword(passwordLoginController.text);

        context.goNamedAuth(RouteName.home);
      }
    } catch (e) {
      setLoading(false);
      setError(e as Exception);
    } finally {
      setLoading(false);
    }
  }

  Future<void> _encryptPassword(String password) async {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encryptedPassword = encrypter.encrypt(password, iv: iv);

    await AppManager.instance.prefs
        .setString('encrypted_password', encryptedPassword.base64);
  }
}
