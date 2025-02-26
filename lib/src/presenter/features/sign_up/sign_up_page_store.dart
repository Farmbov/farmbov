// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/domain/models/brazilian_state.dart';
import 'package:uuid/uuid.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/domain/models/firestore/user_model.dart';
import 'package:farmbov/src/presenter/shared/modals/create_account_success_modal.dart';
import 'package:farmbov/src/domain/stores/auth_store.dart';

class SignUpPageStore extends MobXStore<bool> {
  SignUpPageStore() : super(false);

  final authStore = AuthStore();

  final senhaVisibility = Observable(false);
  final confirmeSenhaVisibility = Observable(false);
  final currentPage = Observable(0);
  final createAccountText = Observable("Continuar");
  final selectedState = Observable<BrazilianState?>(null);

  final formKey = GlobalKey<FormState>();

  final complementFocusNode = FocusNode();

  TextEditingController? fullNameController;
  TextEditingController? emailController;
  TextEditingController? senhaController;
  TextEditingController? confirmeSenhaController;
  TextEditingController? documentController;
  TextEditingController? phoneNumberController;

  //ApiCallResponse? apiResultw8i;

  final pageController = PageController(initialPage: 0, keepPage: false,);

  final passwordValidator =
      MatchValidator(errorText: 'As senhas não conferem.');

  init() {
    fullNameController ??= TextEditingController();
    emailController ??= TextEditingController();
    senhaController ??= TextEditingController();
    confirmeSenhaController ??= TextEditingController();
    documentController ??= TextEditingController();
    phoneNumberController ??= TextEditingController();

    pageController.addListener(() {
      if (pageController.page?.round() != currentPage.value) {
        currentPage.value = pageController.page?.round() ?? 0;
      }
    });
  }

  dispose() {
    fullNameController?.dispose();
    documentController?.dispose();
    phoneNumberController?.dispose();
    emailController?.dispose();
    senhaController?.dispose();
    confirmeSenhaController?.dispose();
  }

  Future<void> submitForm(BuildContext context) async {
    try {
      setLoading(true);

      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return setLoading(false);
      }

      await authStore.signOut();

      final user = await authStore.createAccount(
        emailController!.text,
        senhaController!.text,
        displayName: fullNameController!.text,
      );

      if (user == null) {
        return setLoading(false);
      }

      String? uuid = user.uid;
      if (uuid.isEmpty) {
        uuid = FirebaseAuth.instance.currentUser?.uid ?? const Uuid().v1();
      }

      final usersCreateData = createUserData(
        fullName: fullNameController?.text,
        email: emailController?.text,
        document: documentController?.text.replaceAll('.', '').replaceAll('-', ''),
        phoneNumber: phoneNumberController?.text,
        create: true,
      );

      await UserModel.collection.doc(uuid).set(usersCreateData);

      authStore.signOut();
      
      setLoading(false);


      // TODO: auto login
      _showSuccessModal(context);
    } catch (e) {
      // TODO: on error, delete user/context
      setError(e as Exception);
      AlertManager.showToast('Erro ao cadastrar usuário');
    } finally {
      setLoading(false);
    }
  }

  void togglePasswordVisibility() {
    senhaVisibility.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    confirmeSenhaVisibility.toggle();
  }

  void _showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const CreateAccountSuccessModal(),
    );
  }

  void changeCreateAccountText() {
    // TODO: ao apertar enter, enviar ou ir para a próxima página
    createAccountText.value =
        pageController.page == 1 ? 'Criar conta' : 'Continuar';
  }
}
