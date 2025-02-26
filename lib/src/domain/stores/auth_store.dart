import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/providers/onesingal_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/domain/repositories/user_repository.dart';

class AuthStore extends MobXStore<User?> {
  AuthStore() : super(null);

  final repository = UserRepository();

  Future<User?> signIn(String email, String password) async {
    setLoading(true);

    try {
      final userCredential = await repository.signIn(email, password);
      if (userCredential == null) {
        throw Exception('Invalid username or password');
      }

      setLoading(false);
      update(userCredential.user);

      OneSignalService.setUser(email, userCredential.user?.uid ?? '');

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      setError(e);
      AlertManager.showToast(
          '(${e.code}) Erro ao fazer login, tente novamente mais tarde.');
    } catch (e) {
      setLoading(false);
      setError(e as Exception);
      AlertManager.showToast(
          'Erro ao fazer login, tente novamente mais tarde.');
    } finally {
      setLoading(false);
    }
    return null;
  }

  Future<User?> createAccount(
    String email,
    String password, {
    String? displayName,
  }) async {
    setLoading(true);

    try {
      final userCredential =
          await repository.createAccountWithEmail(email, password);
      if (userCredential == null) {
        throw Exception('Invalid user');
      }

      setLoading(false);
      userCredential.user?.updateDisplayName(displayName);
      update(userCredential.user);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      setError(e);
      AlertManager.showToast(
          '(${e.code}) Erro ao fazer cadastro, tente novamente mais tarde.');
    } catch (e) {
      setLoading(false);
      setError(e as Exception);
      AlertManager.showToast(
          'Erro ao fazer cadastro, tente novamente mais tarde.');
    } finally {
      setLoading(false);
    }
    return null;
  }

  Future<void> resetPassword(String email) async {
    setLoading(true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setLoading(false);
    } on FirebaseAuthException catch (e) {
      setError(e);
      AlertManager.showToast(
          '(${e.code}) Erro ao redefinir senha, tente novamente mais tarde.');
    } catch (e) {
      setLoading(false);
      setError(e as Exception);
      AlertManager.showToast(
          'Erro ao redefinir senha, tente novamente mais tarde.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    await repository.signOut();
    AppManager.instance.clearUser();
    update(null);
  }

  Future<void> getCurrentUser() async {
    final repository = UserRepository();
    final user = repository.getCurrentUser();
    update(user);
  }
}
