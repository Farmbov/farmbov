import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:farmbov/src/domain/models/firestore/user_model.dart';

part 'account_update_page_model.freezed.dart';

@freezed
class AccountUpdatePageModel with _$AccountUpdatePageModel {
  const factory AccountUpdatePageModel({
    UserModel? user,
    @Default(false) bool isMediaUploading,
    String? uploadedFileUrl,
  }) = _AccountUpdatePageModel;
}
