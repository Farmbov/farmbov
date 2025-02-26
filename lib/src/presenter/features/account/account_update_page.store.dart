// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/common/helpers/strings_helpers.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/providers/storage_provider.dart';
import 'package:farmbov/src/common/providers/upload_media.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/features/account/account_update_page_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:image_cropper/image_cropper.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/domain/models/firestore/user_model.dart';
import 'package:farmbov/src/domain/repositories/user_repository.dart';

class AccountUpdatePageStore extends MobXStore<AccountUpdatePageModel> {
  AccountUpdatePageStore() : super(const AccountUpdatePageModel());

  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController ufController = TextEditingController();

  init() {
    _loadModel();
  }

  dispose() {
    nameController.dispose();
    documentController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    zipCodeController.dispose();
    addressController.dispose();
    complementController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    ufController.dispose();
  }

  void _loadModel() async {
    try {
      setLoading(true);

      final userReference = await _getUserReference();
      final model = await UserModel.getDocumentOnce(userReference);

      nameController.text = model.fullName ?? '';
      documentController.text = (model.document?.isEmpty ?? true)
          ? ''
          : StringHelpers.formatCPF(model.document!);
      documentController.text = model.document ?? '';
      emailController.text = model.email ?? '';
      telefoneController.text = model.phoneNumber ?? '';
      zipCodeController.text = model.zipCode ?? '';
      addressController.text = model.address ?? '';
      complementController.text = model.complement ?? '';
      neighborhoodController.text = model.neighborhood ?? '';
      cityController.text = model.city ?? '';
      ufController.text = model.state ?? '';

      update(
        state.copyWith(
            user: UserModel(
          (u) => u..photoUrl = model.photoUrl,
        )),
      );
    } catch (e) {
      setLoading(false);
      setError(e);
      AlertManager.showToast('Erro ao carregar dados do usuário.');
    } finally {
      setLoading(false);
    }
  }

  void edit(
    BuildContext context,
  ) async {
    try {
      setLoading(true);

      if (formKey.currentState == null ||
          formKey.currentState?.validate() == false) {
        return;
      }

      final userData = createUserData(
        fullName: nameController.text,
        email: emailController.text,
        phoneNumber: telefoneController.text,
        document:
            documentController.text.replaceAll('.', '').replaceAll('-', ''),
        create: false,
      );

      final currentUserReference = await _getUserReference();

      await _persistUser(userData, currentUserReference);

      final updatedUser =
          await UserModel.getDocumentOnce(await _getUserReference());

      // Try update email flow
      final oldEmail = updatedUser.email ?? '';
      final newEmail = emailController.text;
      if (oldEmail != newEmail) {
        final emailUpdated = await tryUpdateUserEmail(
          oldEmail,
          newEmail,
        );
        if (emailUpdated == false) {
          emailController.text = oldEmail;
          return;
        }

        await _persistUser({"email": newEmail}, currentUserReference);
      }

      FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);

      // TODO: improve
      AppManager.instance
          .firebaseUserStream()
          .listen((user) => AppManager.instance.updateUser(user));

      AlertManager.showToast('Dados atualizados com sucesso');
    } catch (e) {
      setError(e);
      AlertManager.showToast('Erro ao atualizar dados do usuário.');
    } finally {
      setLoading(false);
    }
  }


  Future<File?> cropImage(BuildContext context, String sourcePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar Imagem',
          toolbarColor: AppColors.primaryGreen,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.primaryGreen,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          title: 'Editar Imagem',
          
        ),
        WebUiSettings(context: context)
      ],
    );

    if (croppedFile == null) {
      throw Exception('Nenhuma imagem foi cortada');
    }

    return File(croppedFile.path);
  }

  Future<void> uploadImage(BuildContext context) async {
    final selectedMedia = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      multiImage: false,
      imageQuality: 50,
    );

    String? avatar = selectedMedia?.first.filePath;
    if (kIsWeb == false) {
      final croppedImage =
          await cropImage(context, selectedMedia!.first.filePath!);
      avatar = croppedImage?.path;
    }

    if (avatar?.isEmpty ?? true) {
      throw Exception('Erro ao selecionar imagem');
    }

    if (avatar != null &&
        selectedMedia!
            .every((m) => validateFileFormat(m.storagePath, context))) {
      update(state.copyWith(
        isMediaUploading: true,
      ));

      String? imageUrl;
      UserModel? updatedUser;

      try {
        // final avatarImage = selectedMedia.first;
        // FFUploadedFile(
        //   name: avatarImage.storagePath.split('/').last,
        //   bytes: avatarImage.bytes,
        //   height: avatarImage.dimensions?.height,
        //   width: avatarImage.dimensions?.width,
        // );

        final avatarFile = File(avatar);
        
    if (kIsWeb == false) {
        imageUrl = await uploadData(selectedMedia.first.storagePath, await avatarFile.readAsBytes());

    }else{
        imageUrl = await uploadData(selectedMedia.first.storagePath, selectedMedia.first.bytes);

    }


        if (imageUrl?.isEmpty ?? true) {
          throw Exception('Erro ao selecionar imagem');
        }

        final userData = createUserData(
          photoUrl: imageUrl,
          create: false,
        );

        final currentUserReference = await _getUserReference();

        await _persistUser(userData, currentUserReference);

        updatedUser =
            await UserModel.getDocumentOnce(await _getUserReference());
      } catch (e) {
        setLoading(false);
        AlertManager.showToast('Erro ao atualizar foto do usuário.');
      } finally {
        setLoading(false);
        //ScaffoldMessenger.of(context).hideCurrentSnackBar();\
        update(state.copyWith(
          isMediaUploading: false,
          uploadedFileUrl: imageUrl,
          user: updatedUser,
        ));
      }
    }
  }




  Future<void> _persistUser(Map<String, dynamic> model,
      DocumentReference<Object?> userReference) async {
    await UserModel.collection
        .doc(userReference.path.split('/').last)
        .update(model);
  }

  Future<DocumentReference<Object?>> _getUserReference() async {
    final currentUserId = UserRepository().getCurrentUser()?.uid;
    if (currentUserId == null) {
      throw Exception('Usuário não encontrado');
    }
    return UserModel.collection.doc(currentUserId);
  }

  Future<String?> _getPassword() async {
    final encryptedPassword =
        AppManager.instance.prefs.getString('encrypted_password');

    if (encryptedPassword != null) {
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);
      return decryptedPassword;
    }
    return null;
  }

  Future<bool> tryUpdateUserEmail(String oldEmail, String newEmail) async {
    try {
      final password = await _getPassword();

      if (password != null) {
        final credential =
            EmailAuthProvider.credential(email: oldEmail, password: password);
        final autenticated = await FirebaseAuth.instance.currentUser
            ?.reauthenticateWithCredential(credential);
        await autenticated?.user?.verifyBeforeUpdateEmail(newEmail);
      } else {
        // TODO: popup pedindo a senha
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}
