import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:farmbov/src/domain/models/area_usage_type_model.dart';

part 'area_update_page_model.freezed.dart';

@freezed
class AreaUpdatePageModel with _$AreaUpdatePageModel {
  const factory AreaUpdatePageModel({
    AreaUsageTypeModel? selectedUsageType,
    String? name,
    double? totalArea,
    int? animalsLotsAmount,
    int? totalCapacity,
    String? notes,
  }) = _AreaUpdatePageModel;
}
