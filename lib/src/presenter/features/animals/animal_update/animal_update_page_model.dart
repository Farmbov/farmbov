import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:farmbov/src/domain/constants/animal_tag_type.dart';

part 'animal_update_page_model.freezed.dart';

@freezed
class AnimalUpdatePageModel with _$AnimalUpdatePageModel {
  const factory AnimalUpdatePageModel({
    @Default(AnimalTagType.common) AnimalTagType selectedAnimalTagType,
    String? selectedSex,
    String? selectedBreed,
    String? selectedLot,
    DateTime? selectedEntryDate,
    DateTime? selectedBirthDate,
    DateTime? selectedWeighingDate,
    @Default(false) bool isMediaUploading,
    String? uploadedFileUrl,
  }) = _AnimalUpdatePageModel;
}
