// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_breed_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AnimalBreedModel> _$animalBreedModelSerializer =
    new _$AnimalBreedModelSerializer();

class _$AnimalBreedModelSerializer
    implements StructuredSerializer<AnimalBreedModel> {
  @override
  final Iterable<Type> types = const [AnimalBreedModel, _$AnimalBreedModel];
  @override
  final String wireName = 'AnimalBreedModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, AnimalBreedModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'active',
      serializers.serialize(object.active, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.ffRef;
    if (value != null) {
      result
        ..add('Document__Reference__Field')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('created_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updated_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    return result;
  }

  @override
  AnimalBreedModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AnimalBreedModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'Document__Reference__Field':
          result.ffRef = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
        case 'active':
          result.active = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
      }
    }

    return result.build();
  }
}

class _$AnimalBreedModel extends AnimalBreedModel {
  @override
  final String? name;
  @override
  final DocumentReference<Object?>? ffRef;
  @override
  final bool active;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$AnimalBreedModel(
          [void Function(AnimalBreedModelBuilder)? updates]) =>
      (new AnimalBreedModelBuilder()..update(updates))._build();

  _$AnimalBreedModel._(
      {this.name,
      this.ffRef,
      required this.active,
      this.createdAt,
      this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        active, r'AnimalBreedModel', 'active');
  }

  @override
  AnimalBreedModel rebuild(void Function(AnimalBreedModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnimalBreedModelBuilder toBuilder() =>
      new AnimalBreedModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnimalBreedModel &&
        name == other.name &&
        ffRef == other.ffRef &&
        active == other.active &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnimalBreedModel')
          ..add('name', name)
          ..add('ffRef', ffRef)
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AnimalBreedModelBuilder
    implements Builder<AnimalBreedModel, AnimalBreedModelBuilder> {
  _$AnimalBreedModel? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AnimalBreedModelBuilder() {
    AnimalBreedModel._initializeBuilder(this);
  }

  AnimalBreedModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _ffRef = $v.ffRef;
      _active = $v.active;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnimalBreedModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AnimalBreedModel;
  }

  @override
  void update(void Function(AnimalBreedModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnimalBreedModel build() => _build();

  _$AnimalBreedModel _build() {
    final _$result = _$v ??
        new _$AnimalBreedModel._(
            name: name,
            ffRef: ffRef,
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'AnimalBreedModel', 'active'),
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
