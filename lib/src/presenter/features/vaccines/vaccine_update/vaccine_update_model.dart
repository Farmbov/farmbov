import 'package:farmbov/src/domain/models/firestore/vaccine_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccine_update_model.freezed.dart';

@freezed
class VaccineUpdatePageModel with _$VaccineUpdatePageModel {
  const factory VaccineUpdatePageModel({
    VaccineModel? model,
    String? name,
    String? description,
    String? lotNumber,
    String? producer,
    String? supplier,
    String? leafletUrl,
    DateTime? dueDate,
    DateTime? fabricationDate,
    int? daysToNextDose,
  }) = _VaccineUpdatePageModel;
}
