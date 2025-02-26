import 'package:farmbov/src/domain/models/firestore/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'side_menu_mobile_model.freezed.dart';

@freezed
class SideMenuMobileModel with _$SideMenuMobileModel {
  const factory SideMenuMobileModel({
    UserModel? user,
    String? fullName,
    String? userDocument,
    String? email,
    String? phone,
    String? photoUrl,
    @Default('') String appVersion,
  }) = _SideMenuMobileModel;
}
