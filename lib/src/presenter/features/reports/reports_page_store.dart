// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/services/storage_service.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

import 'package:farmbov/src/domain/stores/common_base_store.dart';

class ReportsPageStore extends CommonBaseStore {
  ReportsPageStore() : super(null);

  Future<void> saveWidgetAsPdf(
    BuildContext context,
    ScreenshotController screenshotController, {
    String reportTitle = 'Relatório',
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      setLoading(true);

      final screenshot = await screenshotController.capture();

      if (screenshot == null) return;

      final farmName = AppManager.instance.currentUser.currentFarm?.name == null
          ? 'FarmBov'
          : 'Fazenda ${AppManager.instance.currentUser.currentFarm!.name!}';

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Text(
                    reportTitle,
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    farmName,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  if (startDate != null || endDate != null) ...[
                    pw.Text(
                      'Período: ${startDate == null ? 'início' : DateFormat('dd/MM/yyyy').format(startDate)} - ${endDate == null ? 'fim' : DateFormat('dd/MM/yyyy').format(endDate)}',
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ] else ...[
                    pw.Text(
                      '(Todo o período)',
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ],
                  pw.SizedBox(height: 24),
                  pw.Image(pw.MemoryImage(screenshot), fit: pw.BoxFit.contain),
                ],
              ),
            );
          },
        ),
      );

      final fileBytes = await pdf.save();
      final fileName =
          'relatorio-${DateTime.now().microsecondsSinceEpoch.toString()}.pdf';

      if (kIsWeb) {
        await StorageService.saveDataForWeb(
          fileBytes,
          fileName,
          fileExtension: ".pdf",
          mimeType: MimeType.pdf,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relatório salvo no dispositivo.')),
        );

        return;
      }

      final dir = await getTemporaryDirectory();
      final filenamePath = '${dir.path}/$fileName';

      final file = File(filenamePath);
      await file.writeAsBytes(fileBytes);

      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relatório salvo no dispositivo.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível baixar o relatório.')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível baixar o relatório.')),
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> saveFileToDownloadsFolder(
      Uint8List data, String fileName) async {
    Directory? downloadsDirectory;

    if (Platform.isAndroid) {
      downloadsDirectory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      downloadsDirectory = await getDownloadsDirectory();
    }

    final filePath = '${downloadsDirectory?.path}/FarmBov/$fileName';

    final file = File(filePath);

    await file.writeAsBytes(data);
  }
}
