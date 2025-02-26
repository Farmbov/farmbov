// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animal_import_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AnimalImportPageModel {
  FilePickerResult? get uploadResult => throw _privateConstructorUsedError;
  List<PlatformFile> get uploadedFiles => throw _privateConstructorUsedError;
  dynamic get progressValue => throw _privateConstructorUsedError;
  dynamic get progressPercentValue => throw _privateConstructorUsedError;
  bool get isMediaUploading =>
      throw _privateConstructorUsedError; //Serão valores fixos em cada animal importado
  String? get selectedBreed => throw _privateConstructorUsedError;
  String? get selectedLot => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnimalImportPageModelCopyWith<AnimalImportPageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalImportPageModelCopyWith<$Res> {
  factory $AnimalImportPageModelCopyWith(AnimalImportPageModel value,
          $Res Function(AnimalImportPageModel) then) =
      _$AnimalImportPageModelCopyWithImpl<$Res, AnimalImportPageModel>;
  @useResult
  $Res call(
      {FilePickerResult? uploadResult,
      List<PlatformFile> uploadedFiles,
      dynamic progressValue,
      dynamic progressPercentValue,
      bool isMediaUploading,
      String? selectedBreed,
      String? selectedLot});
}

/// @nodoc
class _$AnimalImportPageModelCopyWithImpl<$Res,
        $Val extends AnimalImportPageModel>
    implements $AnimalImportPageModelCopyWith<$Res> {
  _$AnimalImportPageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uploadResult = freezed,
    Object? uploadedFiles = null,
    Object? progressValue = freezed,
    Object? progressPercentValue = freezed,
    Object? isMediaUploading = null,
    Object? selectedBreed = freezed,
    Object? selectedLot = freezed,
  }) {
    return _then(_value.copyWith(
      uploadResult: freezed == uploadResult
          ? _value.uploadResult
          : uploadResult // ignore: cast_nullable_to_non_nullable
              as FilePickerResult?,
      uploadedFiles: null == uploadedFiles
          ? _value.uploadedFiles
          : uploadedFiles // ignore: cast_nullable_to_non_nullable
              as List<PlatformFile>,
      progressValue: freezed == progressValue
          ? _value.progressValue
          : progressValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      progressPercentValue: freezed == progressPercentValue
          ? _value.progressPercentValue
          : progressPercentValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isMediaUploading: null == isMediaUploading
          ? _value.isMediaUploading
          : isMediaUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedBreed: freezed == selectedBreed
          ? _value.selectedBreed
          : selectedBreed // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedLot: freezed == selectedLot
          ? _value.selectedLot
          : selectedLot // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnimalImportPageModelImplCopyWith<$Res>
    implements $AnimalImportPageModelCopyWith<$Res> {
  factory _$$AnimalImportPageModelImplCopyWith(
          _$AnimalImportPageModelImpl value,
          $Res Function(_$AnimalImportPageModelImpl) then) =
      __$$AnimalImportPageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FilePickerResult? uploadResult,
      List<PlatformFile> uploadedFiles,
      dynamic progressValue,
      dynamic progressPercentValue,
      bool isMediaUploading,
      String? selectedBreed,
      String? selectedLot});
}

/// @nodoc
class __$$AnimalImportPageModelImplCopyWithImpl<$Res>
    extends _$AnimalImportPageModelCopyWithImpl<$Res,
        _$AnimalImportPageModelImpl>
    implements _$$AnimalImportPageModelImplCopyWith<$Res> {
  __$$AnimalImportPageModelImplCopyWithImpl(_$AnimalImportPageModelImpl _value,
      $Res Function(_$AnimalImportPageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uploadResult = freezed,
    Object? uploadedFiles = null,
    Object? progressValue = freezed,
    Object? progressPercentValue = freezed,
    Object? isMediaUploading = null,
    Object? selectedBreed = freezed,
    Object? selectedLot = freezed,
  }) {
    return _then(_$AnimalImportPageModelImpl(
      uploadResult: freezed == uploadResult
          ? _value.uploadResult
          : uploadResult // ignore: cast_nullable_to_non_nullable
              as FilePickerResult?,
      uploadedFiles: null == uploadedFiles
          ? _value._uploadedFiles
          : uploadedFiles // ignore: cast_nullable_to_non_nullable
              as List<PlatformFile>,
      progressValue:
          freezed == progressValue ? _value.progressValue! : progressValue,
      progressPercentValue: freezed == progressPercentValue
          ? _value.progressPercentValue!
          : progressPercentValue,
      isMediaUploading: null == isMediaUploading
          ? _value.isMediaUploading
          : isMediaUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedBreed: freezed == selectedBreed
          ? _value.selectedBreed
          : selectedBreed // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedLot: freezed == selectedLot
          ? _value.selectedLot
          : selectedLot // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AnimalImportPageModelImpl implements _AnimalImportPageModel {
  const _$AnimalImportPageModelImpl(
      {this.uploadResult,
      final List<PlatformFile> uploadedFiles = const [],
      this.progressValue = 0,
      this.progressPercentValue = 0,
      this.isMediaUploading = false,
      this.selectedBreed,
      this.selectedLot})
      : _uploadedFiles = uploadedFiles;

  @override
  final FilePickerResult? uploadResult;
  final List<PlatformFile> _uploadedFiles;
  @override
  @JsonKey()
  List<PlatformFile> get uploadedFiles {
    if (_uploadedFiles is EqualUnmodifiableListView) return _uploadedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_uploadedFiles);
  }

  @override
  @JsonKey()
  final dynamic progressValue;
  @override
  @JsonKey()
  final dynamic progressPercentValue;
  @override
  @JsonKey()
  final bool isMediaUploading;
//Serão valores fixos em cada animal importado
  @override
  final String? selectedBreed;
  @override
  final String? selectedLot;

  @override
  String toString() {
    return 'AnimalImportPageModel(uploadResult: $uploadResult, uploadedFiles: $uploadedFiles, progressValue: $progressValue, progressPercentValue: $progressPercentValue, isMediaUploading: $isMediaUploading, selectedBreed: $selectedBreed, selectedLot: $selectedLot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalImportPageModelImpl &&
            (identical(other.uploadResult, uploadResult) ||
                other.uploadResult == uploadResult) &&
            const DeepCollectionEquality()
                .equals(other._uploadedFiles, _uploadedFiles) &&
            const DeepCollectionEquality()
                .equals(other.progressValue, progressValue) &&
            const DeepCollectionEquality()
                .equals(other.progressPercentValue, progressPercentValue) &&
            (identical(other.isMediaUploading, isMediaUploading) ||
                other.isMediaUploading == isMediaUploading) &&
            (identical(other.selectedBreed, selectedBreed) ||
                other.selectedBreed == selectedBreed) &&
            (identical(other.selectedLot, selectedLot) ||
                other.selectedLot == selectedLot));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      uploadResult,
      const DeepCollectionEquality().hash(_uploadedFiles),
      const DeepCollectionEquality().hash(progressValue),
      const DeepCollectionEquality().hash(progressPercentValue),
      isMediaUploading,
      selectedBreed,
      selectedLot);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalImportPageModelImplCopyWith<_$AnimalImportPageModelImpl>
      get copyWith => __$$AnimalImportPageModelImplCopyWithImpl<
          _$AnimalImportPageModelImpl>(this, _$identity);
}

abstract class _AnimalImportPageModel implements AnimalImportPageModel {
  const factory _AnimalImportPageModel(
      {final FilePickerResult? uploadResult,
      final List<PlatformFile> uploadedFiles,
      final dynamic progressValue,
      final dynamic progressPercentValue,
      final bool isMediaUploading,
      final String? selectedBreed,
      final String? selectedLot}) = _$AnimalImportPageModelImpl;

  @override
  FilePickerResult? get uploadResult;
  @override
  List<PlatformFile> get uploadedFiles;
  @override
  dynamic get progressValue;
  @override
  dynamic get progressPercentValue;
  @override
  bool get isMediaUploading;
  @override //Serão valores fixos em cada animal importado
  String? get selectedBreed;
  @override
  String? get selectedLot;
  @override
  @JsonKey(ignore: true)
  _$$AnimalImportPageModelImplCopyWith<_$AnimalImportPageModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
