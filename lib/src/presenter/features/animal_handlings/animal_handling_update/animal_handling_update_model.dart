import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:farmbov/src/domain/constants/animal_handling_types.dart';
import 'package:farmbov/src/domain/models/firestore/animal_handling_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';

part 'animal_handling_update_model.freezed.dart';

@freezed
class AnimalHandlingUpdatePageModel with _$AnimalHandlingUpdatePageModel {
  const factory AnimalHandlingUpdatePageModel({
    AnimalHandlingModel? model,
    AnimalModel? selectedAnimal,
    AnimalModel? selectedMaleAnimal,
    AnimalHandlingTypes? handlingType,
    DateTime? weightHandlingDate,
    DateTime? healthHandlingDate,
    String? vaccine,
    DateTime? reproductionHandlingDate,
    DateTime? pregnantLikelyDate,
    @Default(false) bool isPregnant,
    @Default(false) bool isLastStep,
  }) = _AnimalHandlingUpdatePageModel;
}
