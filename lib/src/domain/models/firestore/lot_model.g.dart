// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LotModel> _$lotModelSerializer = new _$LotModelSerializer();

class _$LotModelSerializer implements StructuredSerializer<LotModel> {
  @override
  final Iterable<Type> types = const [LotModel, _$LotModel];
  @override
  final String wireName = 'LotModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, LotModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'active',
      serializers.serialize(object.active, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.area;
    if (value != null) {
      result
        ..add('area')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.animalsCapacity;
    if (value != null) {
      result
        ..add('animalsCapacity')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.notes;
    if (value != null) {
      result
        ..add('notes')
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
  LotModel deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LotModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'area':
          result.area = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'animalsCapacity':
          result.animalsCapacity = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'notes':
          result.notes = serializers.deserialize(value,
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

class _$LotModel extends LotModel {
  @override
  final String? area;
  @override
  final String? name;
  @override
  final int? animalsCapacity;
  @override
  final String? notes;
  @override
  final DocumentReference<Object?>? ffRef;
  @override
  final bool active;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$LotModel([void Function(LotModelBuilder)? updates]) =>
      (new LotModelBuilder()..update(updates))._build();

  _$LotModel._(
      {this.area,
      this.name,
      this.animalsCapacity,
      this.notes,
      this.ffRef,
      required this.active,
      this.createdAt,
      this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(active, r'LotModel', 'active');
  }

  @override
  LotModel rebuild(void Function(LotModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LotModelBuilder toBuilder() => new LotModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LotModel &&
        area == other.area &&
        name == other.name &&
        animalsCapacity == other.animalsCapacity &&
        notes == other.notes &&
        ffRef == other.ffRef &&
        active == other.active &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, area.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, animalsCapacity.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LotModel')
          ..add('area', area)
          ..add('name', name)
          ..add('animalsCapacity', animalsCapacity)
          ..add('notes', notes)
          ..add('ffRef', ffRef)
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class LotModelBuilder implements Builder<LotModel, LotModelBuilder> {
  _$LotModel? _$v;

  String? _area;
  String? get area => _$this._area;
  set area(String? area) => _$this._area = area;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _animalsCapacity;
  int? get animalsCapacity => _$this._animalsCapacity;
  set animalsCapacity(int? animalsCapacity) =>
      _$this._animalsCapacity = animalsCapacity;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

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

  LotModelBuilder() {
    LotModel._initializeBuilder(this);
  }

  LotModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _area = $v.area;
      _name = $v.name;
      _animalsCapacity = $v.animalsCapacity;
      _notes = $v.notes;
      _ffRef = $v.ffRef;
      _active = $v.active;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LotModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LotModel;
  }

  @override
  void update(void Function(LotModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LotModel build() => _build();

  _$LotModel _build() {
    final _$result = _$v ??
        new _$LotModel._(
            area: area,
            name: name,
            animalsCapacity: animalsCapacity,
            notes: notes,
            ffRef: ffRef,
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'LotModel', 'active'),
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
