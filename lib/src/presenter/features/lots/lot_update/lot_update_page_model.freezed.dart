// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lot_update_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LotUpdatePageModel {
  String? get name => throw _privateConstructorUsedError;
  String? get selectedArea => throw _privateConstructorUsedError;
  int? get animalsCapacity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LotUpdatePageModelCopyWith<LotUpdatePageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LotUpdatePageModelCopyWith<$Res> {
  factory $LotUpdatePageModelCopyWith(
          LotUpdatePageModel value, $Res Function(LotUpdatePageModel) then) =
      _$LotUpdatePageModelCopyWithImpl<$Res, LotUpdatePageModel>;
  @useResult
  $Res call(
      {String? name,
      String? selectedArea,
      int? animalsCapacity,
      String? notes});
}

/// @nodoc
class _$LotUpdatePageModelCopyWithImpl<$Res, $Val extends LotUpdatePageModel>
    implements $LotUpdatePageModelCopyWith<$Res> {
  _$LotUpdatePageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? selectedArea = freezed,
    Object? animalsCapacity = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedArea: freezed == selectedArea
          ? _value.selectedArea
          : selectedArea // ignore: cast_nullable_to_non_nullable
              as String?,
      animalsCapacity: freezed == animalsCapacity
          ? _value.animalsCapacity
          : animalsCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LotUpdatePageModelImplCopyWith<$Res>
    implements $LotUpdatePageModelCopyWith<$Res> {
  factory _$$LotUpdatePageModelImplCopyWith(_$LotUpdatePageModelImpl value,
          $Res Function(_$LotUpdatePageModelImpl) then) =
      __$$LotUpdatePageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      String? selectedArea,
      int? animalsCapacity,
      String? notes});
}

/// @nodoc
class __$$LotUpdatePageModelImplCopyWithImpl<$Res>
    extends _$LotUpdatePageModelCopyWithImpl<$Res, _$LotUpdatePageModelImpl>
    implements _$$LotUpdatePageModelImplCopyWith<$Res> {
  __$$LotUpdatePageModelImplCopyWithImpl(_$LotUpdatePageModelImpl _value,
      $Res Function(_$LotUpdatePageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? selectedArea = freezed,
    Object? animalsCapacity = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$LotUpdatePageModelImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedArea: freezed == selectedArea
          ? _value.selectedArea
          : selectedArea // ignore: cast_nullable_to_non_nullable
              as String?,
      animalsCapacity: freezed == animalsCapacity
          ? _value.animalsCapacity
          : animalsCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LotUpdatePageModelImpl implements _LotUpdatePageModel {
  const _$LotUpdatePageModelImpl(
      {this.name, this.selectedArea, this.animalsCapacity, this.notes});

  @override
  final String? name;
  @override
  final String? selectedArea;
  @override
  final int? animalsCapacity;
  @override
  final String? notes;

  @override
  String toString() {
    return 'LotUpdatePageModel(name: $name, selectedArea: $selectedArea, animalsCapacity: $animalsCapacity, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LotUpdatePageModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.selectedArea, selectedArea) ||
                other.selectedArea == selectedArea) &&
            (identical(other.animalsCapacity, animalsCapacity) ||
                other.animalsCapacity == animalsCapacity) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, selectedArea, animalsCapacity, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LotUpdatePageModelImplCopyWith<_$LotUpdatePageModelImpl> get copyWith =>
      __$$LotUpdatePageModelImplCopyWithImpl<_$LotUpdatePageModelImpl>(
          this, _$identity);
}

abstract class _LotUpdatePageModel implements LotUpdatePageModel {
  const factory _LotUpdatePageModel(
      {final String? name,
      final String? selectedArea,
      final int? animalsCapacity,
      final String? notes}) = _$LotUpdatePageModelImpl;

  @override
  String? get name;
  @override
  String? get selectedArea;
  @override
  int? get animalsCapacity;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$LotUpdatePageModelImplCopyWith<_$LotUpdatePageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
