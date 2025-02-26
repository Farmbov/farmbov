// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/domain/services/storage_service.dart';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:farmbov/src/common/router/route_name.dart';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:path_provider/path_provider.dart';

import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';
import 'package:farmbov/src/domain/constants/import_animal_templates.dart';
import 'package:farmbov/src/presenter/features/animals/animal_import/animal_import_page_model.dart';

import 'exceptions/errors.dart';

class AnimalImportPageStore extends MobXStore<AnimalImportPageModel> {
  AnimalImportPageStore() : super(const AnimalImportPageModel());

// Método para atualizar a raça selecionada
  void setSelectedBreed(String? breed) {
    update(state.copyWith(selectedBreed: breed));
  }

  // Método para atualizar o lote selecionado
  void setSelectedLot(String? lot) {
    update(state.copyWith(selectedLot: lot));
  }

  Future<Uint8List?> _loadFile() async {
    try {
      final byteData = await rootBundle.load(localFilePath);
      return byteData.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<void> downloadTemplate(BuildContext context) async {
    try {
      var templateFile = await _loadFile();

      if (templateFile == null) {
        // https://firebasestorage.googleapis.com/v0/b/farmbov-af05a.appspot.com/o/templates%2Fanimal_upload_template.csv?alt=media&token=2f43bd5d-db5c-48b3-807f-c34357afd130
        final storageRef = FirebaseStorage.instance.ref().child(serverFilePath);

        templateFile = await storageRef.getData();
      }

      if (templateFile == null) {
        throw Exception('Arquivo não encontrado.');
      }

      const fileName = 'farmbov-planilha.csv';

      if (kIsWeb) {
        await StorageService.saveDataForWeb(
          templateFile,
          fileName,
          // fileExtension: ".csv",
          mimeType: MimeType.microsoftExcel,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Planilha salva no dispositivo.')),
        );

        return;
      }

      final params = SaveFileDialogParams(
        data: templateFile,
        fileName: fileName,
      );
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      final validFile = io.File(finalPath!).existsSync();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('Planilha salva no dispositivo.'),
              if (validFile) ...[
                const Spacer(),
                TextButton(
                  onPressed: () => OpenFile.open(finalPath),
                  child: const Text('ABRIR'),
                ),
              ],
            ],
          ),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao baixar planilha.')),
      );
    }
  }

  void openFile(String path) {}

  Future<void> limparArquivosTemporarios() async {
    try {
      io.Directory tempDir = await getTemporaryDirectory();
      await tempDir.delete(recursive: true);
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> selectFiles() async {
    if (!kIsWeb) {
      await limparArquivosTemporarios();
    }

    final uploadResult = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      //allowedExtensions: ['xlsx', 'xlsm', 'csv'],
      allowedExtensions: ['csv'],
    );

    // TODO: save to users uploads file folder (create)
    update(
      state.copyWith(
        uploadResult: uploadResult,
        uploadedFiles: uploadResult?.files ?? [],
      ),
    );
  }

  Stream<List<int>>? readFileFromMemory(fileContent) {
    // Create a StreamController to emit the file content
    StreamController<List<int>> controller =
        StreamController<List<int>>.broadcast();

    // Create a ByteData instance from the Uint8List
    ByteData byteData = ByteData.view(fileContent.buffer);

    // Get the length of the file content
    int length = byteData.lengthInBytes;

    // Create a stream by chunking the file content
    Timer.run(() {
      for (int i = 0; i < length; i += 1024) {
        int chunkSize = length - i >= 1024 ? 1024 : length - i;
        List<int> chunk = byteData.buffer.asUint8List(i, chunkSize);
        controller.add(chunk);
      }
      controller.close();
    });

    // Return the stream
    return controller.stream;
  }

  void submit(BuildContext context) async {
    setLoading(true);
    try {
      var fileIndex = 1;
      var animalsUploaded = 0;

      // Vai agrupar todos os animais importados e salvar de uma só vez, economiza na qtd de escrita e evita travamentos
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var uploadFile in state.uploadedFiles) {
        if (kIsWeb) {
          if (uploadFile.bytes == null) continue;
        } else {
          if (uploadFile.path?.isEmpty ?? false) continue;
        }

        Stream<List<int>>? input = const Stream.empty();

        if (kIsWeb) {
          input = readFileFromMemory(uploadFile.bytes!);
        } else {
          input = io.File(uploadFile.path!).openRead();
          //input = uploadFile.readStream;
        }

        if (input == null) continue;

        final fileFields = await input
            .transform(utf8.decoder)
            .transform(
              const CsvToListConverter(
                shouldParseNumbers: false,
                csvSettingsDetector: FirstOccurrenceSettingsDetector(
                  eols: ['\n', '\r\n'],
                ),
              ),
            )
            .skip(1)
            .toList();

        var fieldIndex = 1;
        for (var fields in fileFields) {
          try {
            final tagNumber = fields[3].toString().trim();
            if (tagNumber == brincoAnimalTeste) break;

            var inputFormat = DateFormat('dd/MM/yyyy');

            // Parse datas
            final birthDate = inputFormat
                .parse(fields[0].toString().trim()); // data_nascimento
            final entryDate =
                inputFormat.parse(fields[1].toString().trim()); // data_entrada
            final weighingDate =
                inputFormat.parse(fields[2].toString().trim()); // data_pesagem

            //Validações datas
            // Verificação: data de entrada não pode ser anterior à data de nascimento
            if (entryDate.isBefore(birthDate)) {
              throw EntryDateBeforeBirthDateError(
                  fieldIndex, entryDate, birthDate);
            }

            // Verificação: data de pesagem não pode anteceder a data de nascimento ou a data de entrada
            if (weighingDate.isBefore(birthDate)) {
              throw WeighingDateBeforeBirthDateError(
                  fieldIndex, weighingDate, birthDate);
            }

            if (weighingDate.isBefore(entryDate)) {
              throw WeighingDateBeforeEntryDateError(
                  fieldIndex, weighingDate, entryDate);
            }

            // Se todas as verificações forem satisfeitas, cria o animal
            final animalCreateData = createAnimalModelData(
              entryDate: entryDate, // data_entrada
              birthDate: birthDate, // data_nascimento
              weighingDate: weighingDate, // data_pesagem
              tagNumber: fields[3].toString().trim(), // numero_brinco
              momTagNumber: fields[4].toString().trim(), // numero_brinco_mae
              dadTagNumber: fields[5].toString().trim(), // numero_brinco_pai
              notes: fields[6].toString().trim(), // observacao
              weight: double.tryParse(fields[7].toString().trim()), // peso
              sex: fields[8].toString().trim(), // sexo
              lot: state.selectedLot, // Valor de lote selecionado no dropdown
              breed:
                  state.selectedBreed, // Valor de raça selecionado no dropdown
              create: true,
            );

            // Cria uma referência para cada novo documento, baseado em cada linha do csv
            final docRef = AnimalModel.collection.doc();
            //add ao batch de documentos
            batch.set(docRef, animalCreateData);

            animalsUploaded++;
          } on EntryDateBeforeBirthDateError catch (e) {
            // Exibe um SnackBar para o erro de data de entrada anterior à data de nascimento
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            animalsUploaded = 0;
            break;
          } on WeighingDateBeforeBirthDateError catch (e) {
            // Exibe um SnackBar para o erro de data de pesagem anterior à data de nascimento
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            animalsUploaded = 0;
            break;
          } on WeighingDateBeforeEntryDateError catch (e) {
            // Exibe um SnackBar para o erro de data de pesagem anterior à data de entrada
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            animalsUploaded = 0;
            break;
          } catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                      'Falha ao importar linha ($fieldIndex) do $fileIndexº arquivo.')),
            );

            // Se houver qualquer erro no loop, para não tentar realizar commit em batch

            animalsUploaded = 0;
            break;
          } finally {
            fieldIndex++;
          }
        }

        fileIndex++;
      }

      if (animalsUploaded == 0) {
        return showDialog(
          context: context,
          builder: (_) => const BaseAlertModal(
              title: 'Nenhum animal importado',
              type: BaseModalType.warning,
              description:
                  "A planilha foi importada, porém nenhum animal foi adicionado. Verifique se os dados estão corretos e tente novamente.",
              popScopePageRoute: 'animais/importar',
              showCancel: false,
              actionCallback: null),
        );
      } else {
        // Escreve o batch de documentos de uma só vez no firebase
        await batch.commit();
      }

      showInsertSuccessModal(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Falha ao importar planilha. Verifique se os dados estão corretos e tente novamente.')),
      );
    } finally {
      setLoading(false);
    }
  }

  // TODO: move to utils
  String getFileSize(
    int bytes, {
    int decimals = 0,
  }) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  void showInsertSuccessModal(BuildContext context) {
    context.pop();
    showDialog(
      context: context,
      builder: (_) => const BaseAlertModal(
        title: 'Planilha enviada com sucesso!',
        description:
            "Sua planilha foi enviada com sucesso, seus animais já estão disponíveis na área “meus animais”.",
        popScopePageRoute: RouteName.home,
        showCancel: false,
      ),
    );
  }
}
