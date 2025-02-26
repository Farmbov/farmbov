import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal_import_page_model.freezed.dart';

@freezed
class AnimalImportPageModel with _$AnimalImportPageModel {
  const factory AnimalImportPageModel({
    FilePickerResult? uploadResult,
    @Default([]) List<PlatformFile> uploadedFiles,
    @Default(0) progressValue,
    @Default(0) progressPercentValue,
    @Default(false) bool isMediaUploading,
    //Serão valores fixos em cada animal importado
    String? selectedBreed,
    String? selectedLot,
  }) = _AnimalImportPageModel;
}
