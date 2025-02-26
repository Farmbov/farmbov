import 'package:freezed_annotation/freezed_annotation.dart';


part 'sign_in_page_model.freezed.dart';

@freezed
class SignInPageModel with _$SignInPageModel {
  const factory SignInPageModel({
    @Default(true) bool saveLogin,
    @Default(false) bool passwordLoginVisibility,
  }) = _SignInPageModel;
}
