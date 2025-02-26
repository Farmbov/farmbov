// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SignInPageModel {
  bool get saveLogin => throw _privateConstructorUsedError;
  bool get passwordLoginVisibility => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SignInPageModelCopyWith<SignInPageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInPageModelCopyWith<$Res> {
  factory $SignInPageModelCopyWith(
          SignInPageModel value, $Res Function(SignInPageModel) then) =
      _$SignInPageModelCopyWithImpl<$Res, SignInPageModel>;
  @useResult
  $Res call({bool saveLogin, bool passwordLoginVisibility});
}

/// @nodoc
class _$SignInPageModelCopyWithImpl<$Res, $Val extends SignInPageModel>
    implements $SignInPageModelCopyWith<$Res> {
  _$SignInPageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? saveLogin = null,
    Object? passwordLoginVisibility = null,
  }) {
    return _then(_value.copyWith(
      saveLogin: null == saveLogin
          ? _value.saveLogin
          : saveLogin // ignore: cast_nullable_to_non_nullable
              as bool,
      passwordLoginVisibility: null == passwordLoginVisibility
          ? _value.passwordLoginVisibility
          : passwordLoginVisibility // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignInPageModelImplCopyWith<$Res>
    implements $SignInPageModelCopyWith<$Res> {
  factory _$$SignInPageModelImplCopyWith(_$SignInPageModelImpl value,
          $Res Function(_$SignInPageModelImpl) then) =
      __$$SignInPageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool saveLogin, bool passwordLoginVisibility});
}

/// @nodoc
class __$$SignInPageModelImplCopyWithImpl<$Res>
    extends _$SignInPageModelCopyWithImpl<$Res, _$SignInPageModelImpl>
    implements _$$SignInPageModelImplCopyWith<$Res> {
  __$$SignInPageModelImplCopyWithImpl(
      _$SignInPageModelImpl _value, $Res Function(_$SignInPageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? saveLogin = null,
    Object? passwordLoginVisibility = null,
  }) {
    return _then(_$SignInPageModelImpl(
      saveLogin: null == saveLogin
          ? _value.saveLogin
          : saveLogin // ignore: cast_nullable_to_non_nullable
              as bool,
      passwordLoginVisibility: null == passwordLoginVisibility
          ? _value.passwordLoginVisibility
          : passwordLoginVisibility // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SignInPageModelImpl implements _SignInPageModel {
  const _$SignInPageModelImpl(
      {this.saveLogin = true, this.passwordLoginVisibility = false});

  @override
  @JsonKey()
  final bool saveLogin;
  @override
  @JsonKey()
  final bool passwordLoginVisibility;

  @override
  String toString() {
    return 'SignInPageModel(saveLogin: $saveLogin, passwordLoginVisibility: $passwordLoginVisibility)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInPageModelImpl &&
            (identical(other.saveLogin, saveLogin) ||
                other.saveLogin == saveLogin) &&
            (identical(
                    other.passwordLoginVisibility, passwordLoginVisibility) ||
                other.passwordLoginVisibility == passwordLoginVisibility));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, saveLogin, passwordLoginVisibility);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInPageModelImplCopyWith<_$SignInPageModelImpl> get copyWith =>
      __$$SignInPageModelImplCopyWithImpl<_$SignInPageModelImpl>(
          this, _$identity);
}

abstract class _SignInPageModel implements SignInPageModel {
  const factory _SignInPageModel(
      {final bool saveLogin,
      final bool passwordLoginVisibility}) = _$SignInPageModelImpl;

  @override
  bool get saveLogin;
  @override
  bool get passwordLoginVisibility;
  @override
  @JsonKey(ignore: true)
  _$$SignInPageModelImplCopyWith<_$SignInPageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
