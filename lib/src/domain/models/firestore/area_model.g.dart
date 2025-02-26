// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AreaModel> _$areaModelSerializer = new _$AreaModelSerializer();

class _$AreaModelSerializer implements StructuredSerializer<AreaModel> {
  @override
  final Iterable<Type> types = const [AreaModel, _$AreaModel];
  @override
  final String wireName = 'AreaModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, AreaModel object,
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
    value = object.totalArea;
    if (value != null) {
      result
        ..add('totalArea')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.animalsLotsAmount;
    if (value != null) {
      result
        ..add('animalsLotsAmount')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.totalCapacity;
    if (value != null) {
      result
        ..add('totalCapacity')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.usageType;
    if (value != null) {
      result
        ..add('use_type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
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
  AreaModel deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AreaModelBuilder();

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
        case 'totalArea':
          result.totalArea = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'animalsLotsAmount':
          result.animalsLotsAmount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'totalCapacity':
          result.totalCapacity = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'use_type':
          result.usageType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
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

class _$AreaModel extends AreaModel {
  @override
  final String? name;
  @override
  final double? totalArea;
  @override
  final int? animalsLotsAmount;
  @override
  final int? totalCapacity;
  @override
  final String? usageType;
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

  factory _$AreaModel([void Function(AreaModelBuilder)? updates]) =>
      (new AreaModelBuilder()..update(updates))._build();

  _$AreaModel._(
      {this.name,
      this.totalArea,
      this.animalsLotsAmount,
      this.totalCapacity,
      this.usageType,
      this.notes,
      this.ffRef,
      required this.active,
      this.createdAt,
      this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(active, r'AreaModel', 'active');
  }

  @override
  AreaModel rebuild(void Function(AreaModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AreaModelBuilder toBuilder() => new AreaModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AreaModel &&
        name == other.name &&
        totalArea == other.totalArea &&
        animalsLotsAmount == other.animalsLotsAmount &&
        totalCapacity == other.totalCapacity &&
        usageType == other.usageType &&
        notes == other.notes &&
        ffRef == other.ffRef &&
        active == other.active &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, totalArea.hashCode);
    _$hash = $jc(_$hash, animalsLotsAmount.hashCode);
    _$hash = $jc(_$hash, totalCapacity.hashCode);
    _$hash = $jc(_$hash, usageType.hashCode);
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
    return (newBuiltValueToStringHelper(r'AreaModel')
          ..add('name', name)
          ..add('totalArea', totalArea)
          ..add('animalsLotsAmount', animalsLotsAmount)
          ..add('totalCapacity', totalCapacity)
          ..add('usageType', usageType)
          ..add('notes', notes)
          ..add('ffRef', ffRef)
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AreaModelBuilder implements Builder<AreaModel, AreaModelBuilder> {
  _$AreaModel? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  double? _totalArea;
  double? get totalArea => _$this._totalArea;
  set totalArea(double? totalArea) => _$this._totalArea = totalArea;

  int? _animalsLotsAmount;
  int? get animalsLotsAmount => _$this._animalsLotsAmount;
  set animalsLotsAmount(int? animalsLotsAmount) =>
      _$this._animalsLotsAmount = animalsLotsAmount;

  int? _totalCapacity;
  int? get totalCapacity => _$this._totalCapacity;
  set totalCapacity(int? totalCapacity) =>
      _$this._totalCapacity = totalCapacity;

  String? _usageType;
  String? get usageType => _$this._usageType;
  set usageType(String? usageType) => _$this._usageType = usageType;

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

  AreaModelBuilder() {
    AreaModel._initializeBuilder(this);
  }

  AreaModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _totalArea = $v.totalArea;
      _animalsLotsAmount = $v.animalsLotsAmount;
      _totalCapacity = $v.totalCapacity;
      _usageType = $v.usageType;
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
  void replace(AreaModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AreaModel;
  }

  @override
  void update(void Function(AreaModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AreaModel build() => _build();

  _$AreaModel _build() {
    final _$result = _$v ??
        new _$AreaModel._(
            name: name,
            totalArea: totalArea,
            animalsLotsAmount: animalsLotsAmount,
            totalCapacity: totalCapacity,
            usageType: usageType,
            notes: notes,
            ffRef: ffRef,
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'AreaModel', 'active'),
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
