import 'package:freezed_annotation/freezed_annotation.dart';

part 'lot_update_page_model.freezed.dart';

@freezed
class LotUpdatePageModel with _$LotUpdatePageModel {
  const factory LotUpdatePageModel({
    String? name,
    String? selectedArea,
    int? animalsCapacity,
    String? notes,
  }) = _LotUpdatePageModel;
}