// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/helpers/strings_helpers.dart';
import 'package:farmbov/src/common/providers/storage_provider.dart';
import 'package:farmbov/src/common/providers/upload_media.dart';
import 'package:farmbov/src/common/providers/uploaded_file.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/constants/animal_handling_types.dart';
import 'package:farmbov/src/domain/models/firestore/animal_handling_model.dart';
import 'package:farmbov/src/domain/repositories/lot_repository.dart';
import 'package:farmbov/src/presenter/features/animals/animal_update/animal_update_page.dart';
import 'package:farmbov/src/presenter/features/animals/animal_update/animal_update_page_model.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
//import 'package:ndef/ndef.dart' as ndef;
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

DateFormat format = DateFormat("dd/MM/yyyy");

class AnimalUpdatePageStore extends MobXStore<AnimalUpdatePageModel> {
  AnimalUpdatePageStore() : super(const AnimalUpdatePageModel());

  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  final lotRepository = LotRepositoryImpl();

  init({AnimalModel? model}) {
    _loadModel(model: model);
  }

  dispose() {
    //FlutterNfcKit.finish();
  }

  void _loadModel({AnimalModel? model}) {
    if (model != null) {
      update(
        state.copyWith(
          selectedSex: model.sex,
          selectedBreed: model.breed,
          selectedLot: model.lot,
          selectedEntryDate: model.entryDate ?? getCurrentTimestamp,
          selectedBirthDate: model.birthDate,
          selectedWeighingDate: model.weighingDate,
          uploadedFileUrl: model.photoUrl ?? '',
        ),
      );
    }
  }

  // TODO: finish
  // Future<void> checkNfcTag() async {
  //   var availability = await FlutterNfcKit.nfcAvailability;
  //   if (availability != NFCAvailability.available) return;

  //   // timeout only works on Android, while the latter two messages are only for iOS
  //   var tag = await FlutterNfcKit.poll(
  //       timeout: const Duration(seconds: 10),
  //       iosMultipleTagMessage: "Multiple tags found!",
  //       iosAlertMessage: "Scan your tag");

  //   print(jsonEncode(tag));
  //   if (tag.type == NFCTagType.iso7816) {
  //     var result = await FlutterNfcKit.transceive("00B0950000",
  //         timeout: const Duration(
  //             seconds:
  //                 5)); // timeout is still Android-only, persist until next change
  //     print(result);
  //   }

  //   // read NDEF records if available
  //   if (tag.ndefAvailable ?? false) {
  //     /// decoded NDEF records (see [ndef.NDEFRecord] for details)
  //     /// `UriRecord: id=(empty) typeNameFormat=TypeNameFormat.nfcWellKnown type=U uri=https://github.com/nfcim/ndef`
  //     for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
  //       print(record.toString());
  //     }

  //     /// raw NDEF records (data in hex string)
  //     /// `{identifier: "", payload: "00010203", type: "0001", typeNameFormat: "nfcWellKnown"}`
  //     for (var record
  //         in await FlutterNfcKit.readNDEFRawRecords(cached: false)) {
  //       print(jsonEncode(record).toString());
  //     }
  //   }

  //   // write NDEF records if applicable
  //   if (tag.ndefWritable ?? false) {
  //     // decoded NDEF records
  //     await FlutterNfcKit.writeNDEFRecords([
  //       ndef.UriRecord.fromUri(
  //           Uri.http("https://github.com/nfcim/flutter_nfc_kit"))
  //     ]);
  //     // raw NDEF records
  //     await FlutterNfcKit.writeNDEFRawRecords(
  //         [NDEFRawRecord("00", "0001", "0002", ndef.TypeNameFormat.unknown)]);
  //   }
  // }

  void insert(BuildContext context, GlobalKey<FormState> formKey,
      AnimalFormControllers animalForm) async {
    try {
      setLoading(true);

      if (formKey.currentState == null ||
          formKey.currentState?.validate() == false) {
        setLoading(false);
        return;
      }

      if (await _validateExistisTagNumber(animalForm)) {
        setLoading(false);
        return;
      }

      if (await _validateLotCapacityIsFull()) {
        setLoading(false);
        return;
      }

      final animalCreateData = createAnimalModelData(
        tagNumber: animalForm.tagNumberController.text,
        tagNumberRFID: animalForm.tagNumberRFIDController.text,
        tagType: state.selectedAnimalTagType.name,
        momTagNumber: animalForm.momTagNumberController.text,
        dadTagNumber: animalForm.dadTagNumberController.text,
        sex: animalForm.sexController.text,
        breed: animalForm.breedController.text,
        entryDate: animalForm.entryDateController.text.isNotEmpty
            ? format.parse(animalForm.entryDateController.text)
            : getCurrentTimestamp,
        birthDate: animalForm.birthDateController.text.isNotEmpty
            ? format.parse(animalForm.birthDateController.text)
            : null,
        weighingDate: animalForm.weightingDateController.text.isNotEmpty
            ? format.parse(animalForm.weightingDateController.text)
            : null,
        lot: animalForm.lotController.text,
        weight: animalForm.weightController.text.isEmpty
            ? null
            : double.parse(
                animalForm.weightController.text.replaceFirst(',', '.')),
        notes: animalForm.notesController.text,
        photoUrl: state.uploadedFileUrl,
        create: true,
      );

      await AnimalModel.collection.doc().set(animalCreateData);

      if (state.selectedWeighingDate != null) {
        setLoading(false);
        addWeighingHandling(animalForm.tagNumberController.text,
            state.selectedWeighingDate!, animalForm);
      }

      showInsertSuccessModal(context);
    } catch (e) {
      setError(e as Exception);
      AlertManager.showToast('Erro ao salvar!');
    } finally {
      setLoading(false);
    }
  }

  void edit(AnimalModel model, BuildContext context,
      GlobalKey<FormState> formKey, AnimalFormControllers animalForm) async {
    try {
      setLoading(true);
      if (formKey.currentState == null ||
          formKey.currentState?.validate() == false) {
        return;
      }

      // TODO: fix
      // if ((tagNumberController.text != (model?.tagNumber ?? '') ||
      //         tagNumberRFIDController.text != (model?.tagNumberRFID ?? '')) &&
      //     await _validateExistisTagNumber() == false) {
      //   return;
      // }

      if (await _validateLotCapacityIsFull()) {
        setLoading(false);
        return;
      }

      final modelData = createAnimalModelData(
        tagNumber: animalForm.tagNumberController.text,
        tagNumberRFID: animalForm.tagNumberRFIDController.text,
        tagType: state.selectedAnimalTagType.name,
        momTagNumber: animalForm.momTagNumberController.text,
        dadTagNumber: animalForm.dadTagNumberController.text,
        sex: animalForm.sexController.text,
        breed: animalForm.breedController.text,
        entryDate: animalForm.entryDateController.text.isNotEmpty
            ? format.parse(animalForm.entryDateController.text)
            : getCurrentTimestamp,
        birthDate: animalForm.birthDateController.text.isNotEmpty
            ? format.parse(animalForm.birthDateController.text)
            : null,
        weighingDate: animalForm.weightingDateController.text.isNotEmpty
            ? format.parse(animalForm.weightingDateController.text)
            : null,
        lot: animalForm.lotController.text,
        weight: animalForm.weightController.text.isEmpty
            ? null
            : StringHelpers.tryParseNumber(animalForm.weightController.text),
        notes: animalForm.notesController.text,
        photoUrl: state.uploadedFileUrl,
        create: false,
      );

      await model.ffRef!.update(modelData);
      showEditSuccessModal(context);
    } catch (e) {
      setError(e as Exception);
      AlertManager.showToast('Erro ao Editar!');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> _validateLotCapacityIsFull() async {
    try {
      if (state.selectedLot == null) return false;

      final isFull =
          await lotRepository.getLotCapacityIsFull(state.selectedLot!);

      if (isFull) {
        AlertManager.showToast('Lote cheio! Por favor, selecione outro lote.');
        setLoading(false);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  // TODO: when data de pesagem nao nula, peso obrigatorio
  Future<void> addWeighingHandling(String tagNumber,
      DateTime weightHandlingDate, AnimalFormControllers animalForm) async {
    final manejoCreateData = createManejoRecordData(
      handlingType: AnimalHandlingTypes.pesagem.name,
      tagNumber: tagNumber,
      handlingDate: weightHandlingDate,
      weight: animalForm.weightController.text,
    );

    await AnimalHandlingModel.collection.doc().set(manejoCreateData);
  }

  Future<bool> _validateExistisTagNumber(
      AnimalFormControllers animalForm) async {
    if (animalForm.tagNumberController.text.isNotEmpty) {
      final existingTagNumber = await queryAnimalRecordOnce(
        queryBuilder: (animal) => animal.where('tag_number',
            isEqualTo: animalForm.tagNumberController.text),
      );

      if (existingTagNumber.isNotEmpty) {
        AlertManager.showToast(
            'Brinco já cadastrado! Por favor, insira um brinco diferente.');
        setLoading(false);
        return true;
      }
    }

    if (animalForm.tagNumberRFIDController.text.isNotEmpty) {
      final existingTagNumberRfid = await queryAnimalRecordOnce(
        queryBuilder: (animal) => animal.where('tag_number_rfid',
            isEqualTo: animalForm.tagNumberRFIDController.text),
      );

      if (existingTagNumberRfid.isNotEmpty) {
        AlertManager.showToast(
            'Brinco RFID já cadastrado! Por favor, insira um brinco diferente.');
        setLoading(false);
        return true;
      }
    }

    return false;
  }

  Future<void> uploadImage(BuildContext context) async {
    final selectedMedia = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      multiImage: false,
      imageQuality: 50,
    );
    if (selectedMedia != null &&
        selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
      update(state.copyWith(isMediaUploading: true));

      var selectedUploadedFiles = <FFUploadedFile>[];
      var downloadUrls = <String>[];
      try {
        selectedUploadedFiles = selectedMedia
            .map((m) => FFUploadedFile(
                  name: m.storagePath.split('/').last,
                  bytes: m.bytes,
                  height: m.dimensions?.height,
                  width: m.dimensions?.width,
                ))
            .toList();

        downloadUrls = (await Future.wait(
          selectedMedia.map(
            (m) async => await uploadData(m.storagePath, m.bytes),
          ),
        ))
            .where((u) => u != null)
            .map((u) => u!)
            .toList();
      } catch (e) {
        showUploadMessage(context, 'Erro ao enviar imagem');
      } finally {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        update(state.copyWith(isMediaUploading: false));
      }
      if (selectedUploadedFiles.length == selectedMedia.length &&
          downloadUrls.length == selectedMedia.length) {
        uploadedLocalFile = selectedUploadedFiles.first;
        update(state.copyWith(uploadedFileUrl: downloadUrls.first));
        showUploadMessage(context, 'Imagem enviada');
      } else {
        showUploadMessage(context, 'Erro ao enviar imagem');
        return;
      }
    }
  }

  void showInsertSuccessModal(BuildContext context) {
    context.pop();

    showDialog(
      context: context,
      builder: (_) => const BaseAlertModal(
        type: BaseModalType.success,
        title: 'Animal adicionado com sucesso!',
        description: "Seu animal já está disponível na área “meus animais”.",
        showCancel: false,
        canPop: true,
      ),
    );
  }

  void showEditSuccessModal(BuildContext context) {
    context.pop();

    showDialog(
      context: context,
      builder: (_) => const BaseAlertModal(
        type: BaseModalType.success,
        title: 'Animal atualizado com sucesso!',
        description: "Seu animal já está disponível na área “meus animais”.",
        showCancel: false,
        canPop: true,
      ),
    );
  }
}
