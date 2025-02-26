// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_update_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountUpdatePageModel {
  UserModel? get user => throw _privateConstructorUsedError;
  bool get isMediaUploading => throw _privateConstructorUsedError;
  String? get uploadedFileUrl => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountUpdatePageModelCopyWith<AccountUpdatePageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountUpdatePageModelCopyWith<$Res> {
  factory $AccountUpdatePageModelCopyWith(AccountUpdatePageModel value,
          $Res Function(AccountUpdatePageModel) then) =
      _$AccountUpdatePageModelCopyWithImpl<$Res, AccountUpdatePageModel>;
  @useResult
  $Res call({UserModel? user, bool isMediaUploading, String? uploadedFileUrl});
}

/// @nodoc
class _$AccountUpdatePageModelCopyWithImpl<$Res,
        $Val extends AccountUpdatePageModel>
    implements $AccountUpdatePageModelCopyWith<$Res> {
  _$AccountUpdatePageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isMediaUploading = null,
    Object? uploadedFileUrl = freezed,
  }) {
    return _then(_value.copyWith(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      isMediaUploading: null == isMediaUploading
          ? _value.isMediaUploading
          : isMediaUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadedFileUrl: freezed == uploadedFileUrl
          ? _value.uploadedFileUrl
          : uploadedFileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountUpdatePageModelImplCopyWith<$Res>
    implements $AccountUpdatePageModelCopyWith<$Res> {
  factory _$$AccountUpdatePageModelImplCopyWith(
          _$AccountUpdatePageModelImpl value,
          $Res Function(_$AccountUpdatePageModelImpl) then) =
      __$$AccountUpdatePageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserModel? user, bool isMediaUploading, String? uploadedFileUrl});
}

/// @nodoc
class __$$AccountUpdatePageModelImplCopyWithImpl<$Res>
    extends _$AccountUpdatePageModelCopyWithImpl<$Res,
        _$AccountUpdatePageModelImpl>
    implements _$$AccountUpdatePageModelImplCopyWith<$Res> {
  __$$AccountUpdatePageModelImplCopyWithImpl(
      _$AccountUpdatePageModelImpl _value,
      $Res Function(_$AccountUpdatePageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isMediaUploading = null,
    Object? uploadedFileUrl = freezed,
  }) {
    return _then(_$AccountUpdatePageModelImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      isMediaUploading: null == isMediaUploading
          ? _value.isMediaUploading
          : isMediaUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      uploadedFileUrl: freezed == uploadedFileUrl
          ? _value.uploadedFileUrl
          : uploadedFileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AccountUpdatePageModelImpl implements _AccountUpdatePageModel {
  const _$AccountUpdatePageModelImpl(
      {this.user, this.isMediaUploading = false, this.uploadedFileUrl});

  @override
  final UserModel? user;
  @override
  @JsonKey()
  final bool isMediaUploading;
  @override
  final String? uploadedFileUrl;

  @override
  String toString() {
    return 'AccountUpdatePageModel(user: $user, isMediaUploading: $isMediaUploading, uploadedFileUrl: $uploadedFileUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountUpdatePageModelImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isMediaUploading, isMediaUploading) ||
                other.isMediaUploading == isMediaUploading) &&
            (identical(other.uploadedFileUrl, uploadedFileUrl) ||
                other.uploadedFileUrl == uploadedFileUrl));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, user, isMediaUploading, uploadedFileUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountUpdatePageModelImplCopyWith<_$AccountUpdatePageModelImpl>
      get copyWith => __$$AccountUpdatePageModelImplCopyWithImpl<
          _$AccountUpdatePageModelImpl>(this, _$identity);
}

abstract class _AccountUpdatePageModel implements AccountUpdatePageModel {
  const factory _AccountUpdatePageModel(
      {final UserModel? user,
      final bool isMediaUploading,
      final String? uploadedFileUrl}) = _$AccountUpdatePageModelImpl;

  @override
  UserModel? get user;
  @override
  bool get isMediaUploading;
  @override
  String? get uploadedFileUrl;
  @override
  @JsonKey(ignore: true)
  _$$AccountUpdatePageModelImplCopyWith<_$AccountUpdatePageModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
