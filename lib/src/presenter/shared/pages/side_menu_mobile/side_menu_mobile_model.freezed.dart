// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'side_menu_mobile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SideMenuMobileModel {
  UserModel? get user => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get userDocument => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SideMenuMobileModelCopyWith<SideMenuMobileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SideMenuMobileModelCopyWith<$Res> {
  factory $SideMenuMobileModelCopyWith(
          SideMenuMobileModel value, $Res Function(SideMenuMobileModel) then) =
      _$SideMenuMobileModelCopyWithImpl<$Res, SideMenuMobileModel>;
  @useResult
  $Res call(
      {UserModel? user,
      String? fullName,
      String? userDocument,
      String? email,
      String? phone,
      String? photoUrl,
      String appVersion});
}

/// @nodoc
class _$SideMenuMobileModelCopyWithImpl<$Res, $Val extends SideMenuMobileModel>
    implements $SideMenuMobileModelCopyWith<$Res> {
  _$SideMenuMobileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? fullName = freezed,
    Object? userDocument = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? photoUrl = freezed,
    Object? appVersion = null,
  }) {
    return _then(_value.copyWith(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      userDocument: freezed == userDocument
          ? _value.userDocument
          : userDocument // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SideMenuMobileModelImplCopyWith<$Res>
    implements $SideMenuMobileModelCopyWith<$Res> {
  factory _$$SideMenuMobileModelImplCopyWith(_$SideMenuMobileModelImpl value,
          $Res Function(_$SideMenuMobileModelImpl) then) =
      __$$SideMenuMobileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserModel? user,
      String? fullName,
      String? userDocument,
      String? email,
      String? phone,
      String? photoUrl,
      String appVersion});
}

/// @nodoc
class __$$SideMenuMobileModelImplCopyWithImpl<$Res>
    extends _$SideMenuMobileModelCopyWithImpl<$Res, _$SideMenuMobileModelImpl>
    implements _$$SideMenuMobileModelImplCopyWith<$Res> {
  __$$SideMenuMobileModelImplCopyWithImpl(_$SideMenuMobileModelImpl _value,
      $Res Function(_$SideMenuMobileModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? fullName = freezed,
    Object? userDocument = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? photoUrl = freezed,
    Object? appVersion = null,
  }) {
    return _then(_$SideMenuMobileModelImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      userDocument: freezed == userDocument
          ? _value.userDocument
          : userDocument // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SideMenuMobileModelImpl implements _SideMenuMobileModel {
  const _$SideMenuMobileModelImpl(
      {this.user,
      this.fullName,
      this.userDocument,
      this.email,
      this.phone,
      this.photoUrl,
      this.appVersion = ''});

  @override
  final UserModel? user;
  @override
  final String? fullName;
  @override
  final String? userDocument;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  final String appVersion;

  @override
  String toString() {
    return 'SideMenuMobileModel(user: $user, fullName: $fullName, userDocument: $userDocument, email: $email, phone: $phone, photoUrl: $photoUrl, appVersion: $appVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SideMenuMobileModelImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.userDocument, userDocument) ||
                other.userDocument == userDocument) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, fullName, userDocument,
      email, phone, photoUrl, appVersion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SideMenuMobileModelImplCopyWith<_$SideMenuMobileModelImpl> get copyWith =>
      __$$SideMenuMobileModelImplCopyWithImpl<_$SideMenuMobileModelImpl>(
          this, _$identity);
}

abstract class _SideMenuMobileModel implements SideMenuMobileModel {
  const factory _SideMenuMobileModel(
      {final UserModel? user,
      final String? fullName,
      final String? userDocument,
      final String? email,
      final String? phone,
      final String? photoUrl,
      final String appVersion}) = _$SideMenuMobileModelImpl;

  @override
  UserModel? get user;
  @override
  String? get fullName;
  @override
  String? get userDocument;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get photoUrl;
  @override
  String get appVersion;
  @override
  @JsonKey(ignore: true)
  _$$SideMenuMobileModelImplCopyWith<_$SideMenuMobileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
