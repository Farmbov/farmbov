import 'dart:typed_data';
// import 'package:file_system_access_api/file_system_access_api.dart';
import 'package:file_saver/file_saver.dart';
import 'package:logger/logger.dart';

class StorageService {
  static Future<void> saveDataForWeb(
    Uint8List data,
    String fileName, {
      String fileExtension = '',
   MimeType mimeType = MimeType.other,
  }) async {
    try {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: data,
        ext: fileExtension,
        mimeType: MimeType.microsoftExcel,
      );
      return;
    } catch (e) {
      Logger().e(e);
    }
  }
}
