import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/domain/models/firestore/vaccine_lot_model.dart';
import 'package:farmbov/src/domain/models/firestore/vaccine_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccine_lot_update_model.freezed.dart';

@freezed
class VaccineLotUpdatePageModel with _$VaccineLotUpdatePageModel {
  const factory VaccineLotUpdatePageModel({
    String? vaccineId,
    VaccineModel? selectedVaccine,
    String? lotId,
    LotModel? selectedLot,
    DateTime? applicationDate,
    String? notes,
    VaccineLotModel? model,
    @Default(false) bool readOnly,
  }) = _VaccineLotUpdatePageModel;
}
