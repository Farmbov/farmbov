import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_model.freezed.dart';

@freezed
class HomePageModel with _$HomePageModel {
  const factory HomePageModel({
    List<String>? animalsSelectedSexOptions,
  }) = _HomePageModel;
}
