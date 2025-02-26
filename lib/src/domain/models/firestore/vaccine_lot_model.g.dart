// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccine_lot_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<VaccineLotModel> _$vaccineLotModelSerializer =
    new _$VaccineLotModelSerializer();

class _$VaccineLotModelSerializer
    implements StructuredSerializer<VaccineLotModel> {
  @override
  final Iterable<Type> types = const [VaccineLotModel, _$VaccineLotModel];
  @override
  final String wireName = 'VaccineLotModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, VaccineLotModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'vaccine_id',
      serializers.serialize(object.vaccineId,
          specifiedType: const FullType(String)),
      'lot_id',
      serializers.serialize(object.lotId,
          specifiedType: const FullType(String)),
      'active',
      serializers.serialize(object.active, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.applicationDate;
    if (value != null) {
      result
        ..add('application_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
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
  VaccineLotModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VaccineLotModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'vaccine_id':
          result.vaccineId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'lot_id':
          result.lotId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'application_date':
          result.applicationDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
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

class _$VaccineLotModel extends VaccineLotModel {
  @override
  final String vaccineId;
  @override
  final String lotId;
  @override
  final DateTime? applicationDate;
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

  factory _$VaccineLotModel([void Function(VaccineLotModelBuilder)? updates]) =>
      (new VaccineLotModelBuilder()..update(updates))._build();

  _$VaccineLotModel._(
      {required this.vaccineId,
      required this.lotId,
      this.applicationDate,
      this.notes,
      this.ffRef,
      required this.active,
      this.createdAt,
      this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        vaccineId, r'VaccineLotModel', 'vaccineId');
    BuiltValueNullFieldError.checkNotNull(lotId, r'VaccineLotModel', 'lotId');
    BuiltValueNullFieldError.checkNotNull(active, r'VaccineLotModel', 'active');
  }

  @override
  VaccineLotModel rebuild(void Function(VaccineLotModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VaccineLotModelBuilder toBuilder() =>
      new VaccineLotModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VaccineLotModel &&
        vaccineId == other.vaccineId &&
        lotId == other.lotId &&
        applicationDate == other.applicationDate &&
        notes == other.notes &&
        ffRef == other.ffRef &&
        active == other.active &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vaccineId.hashCode);
    _$hash = $jc(_$hash, lotId.hashCode);
    _$hash = $jc(_$hash, applicationDate.hashCode);
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
    return (newBuiltValueToStringHelper(r'VaccineLotModel')
          ..add('vaccineId', vaccineId)
          ..add('lotId', lotId)
          ..add('applicationDate', applicationDate)
          ..add('notes', notes)
          ..add('ffRef', ffRef)
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class VaccineLotModelBuilder
    implements Builder<VaccineLotModel, VaccineLotModelBuilder> {
  _$VaccineLotModel? _$v;

  String? _vaccineId;
  String? get vaccineId => _$this._vaccineId;
  set vaccineId(String? vaccineId) => _$this._vaccineId = vaccineId;

  String? _lotId;
  String? get lotId => _$this._lotId;
  set lotId(String? lotId) => _$this._lotId = lotId;

  DateTime? _applicationDate;
  DateTime? get applicationDate => _$this._applicationDate;
  set applicationDate(DateTime? applicationDate) =>
      _$this._applicationDate = applicationDate;

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

  VaccineLotModelBuilder() {
    VaccineLotModel._initializeBuilder(this);
  }

  VaccineLotModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vaccineId = $v.vaccineId;
      _lotId = $v.lotId;
      _applicationDate = $v.applicationDate;
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
  void replace(VaccineLotModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$VaccineLotModel;
  }

  @override
  void update(void Function(VaccineLotModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VaccineLotModel build() => _build();

  _$VaccineLotModel _build() {
    final _$result = _$v ??
        new _$VaccineLotModel._(
            vaccineId: BuiltValueNullFieldError.checkNotNull(
                vaccineId, r'VaccineLotModel', 'vaccineId'),
            lotId: BuiltValueNullFieldError.checkNotNull(
                lotId, r'VaccineLotModel', 'lotId'),
            applicationDate: applicationDate,
            notes: notes,
            ffRef: ffRef,
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'VaccineLotModel', 'active'),
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
