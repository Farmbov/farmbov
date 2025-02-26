// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccine_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<VaccineModel> _$vaccineModelSerializer =
    new _$VaccineModelSerializer();

class _$VaccineModelSerializer implements StructuredSerializer<VaccineModel> {
  @override
  final Iterable<Type> types = const [VaccineModel, _$VaccineModel];
  @override
  final String wireName = 'VaccineModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, VaccineModel object,
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
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.lotNumber;
    if (value != null) {
      result
        ..add('lot_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.fabricationDate;
    if (value != null) {
      result
        ..add('fabrication_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.dueDate;
    if (value != null) {
      result
        ..add('due_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.supplier;
    if (value != null) {
      result
        ..add('supplier')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.producer;
    if (value != null) {
      result
        ..add('producer')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.leafletUrl;
    if (value != null) {
      result
        ..add('leaflet_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.daysToNextDose;
    if (value != null) {
      result
        ..add('days_to_next_dose')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
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
  VaccineModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VaccineModelBuilder();

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
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'lot_number':
          result.lotNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'fabrication_date':
          result.fabricationDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'due_date':
          result.dueDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'supplier':
          result.supplier = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'producer':
          result.producer = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'leaflet_url':
          result.leafletUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'days_to_next_dose':
          result.daysToNextDose = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
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

class _$VaccineModel extends VaccineModel {
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? lotNumber;
  @override
  final DateTime? fabricationDate;
  @override
  final DateTime? dueDate;
  @override
  final String? supplier;
  @override
  final String? producer;
  @override
  final String? leafletUrl;
  @override
  final int? daysToNextDose;
  @override
  final DocumentReference<Object?>? ffRef;
  @override
  final bool active;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$VaccineModel([void Function(VaccineModelBuilder)? updates]) =>
      (new VaccineModelBuilder()..update(updates))._build();

  _$VaccineModel._(
      {this.name,
      this.description,
      this.lotNumber,
      this.fabricationDate,
      this.dueDate,
      this.supplier,
      this.producer,
      this.leafletUrl,
      this.daysToNextDose,
      this.ffRef,
      required this.active,
      this.createdAt,
      this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(active, r'VaccineModel', 'active');
  }

  @override
  VaccineModel rebuild(void Function(VaccineModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VaccineModelBuilder toBuilder() => new VaccineModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VaccineModel &&
        name == other.name &&
        description == other.description &&
        lotNumber == other.lotNumber &&
        fabricationDate == other.fabricationDate &&
        dueDate == other.dueDate &&
        supplier == other.supplier &&
        producer == other.producer &&
        leafletUrl == other.leafletUrl &&
        daysToNextDose == other.daysToNextDose &&
        ffRef == other.ffRef &&
        active == other.active &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, lotNumber.hashCode);
    _$hash = $jc(_$hash, fabricationDate.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, supplier.hashCode);
    _$hash = $jc(_$hash, producer.hashCode);
    _$hash = $jc(_$hash, leafletUrl.hashCode);
    _$hash = $jc(_$hash, daysToNextDose.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VaccineModel')
          ..add('name', name)
          ..add('description', description)
          ..add('lotNumber', lotNumber)
          ..add('fabricationDate', fabricationDate)
          ..add('dueDate', dueDate)
          ..add('supplier', supplier)
          ..add('producer', producer)
          ..add('leafletUrl', leafletUrl)
          ..add('daysToNextDose', daysToNextDose)
          ..add('ffRef', ffRef)
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class VaccineModelBuilder
    implements Builder<VaccineModel, VaccineModelBuilder> {
  _$VaccineModel? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _lotNumber;
  String? get lotNumber => _$this._lotNumber;
  set lotNumber(String? lotNumber) => _$this._lotNumber = lotNumber;

  DateTime? _fabricationDate;
  DateTime? get fabricationDate => _$this._fabricationDate;
  set fabricationDate(DateTime? fabricationDate) =>
      _$this._fabricationDate = fabricationDate;

  DateTime? _dueDate;
  DateTime? get dueDate => _$this._dueDate;
  set dueDate(DateTime? dueDate) => _$this._dueDate = dueDate;

  String? _supplier;
  String? get supplier => _$this._supplier;
  set supplier(String? supplier) => _$this._supplier = supplier;

  String? _producer;
  String? get producer => _$this._producer;
  set producer(String? producer) => _$this._producer = producer;

  String? _leafletUrl;
  String? get leafletUrl => _$this._leafletUrl;
  set leafletUrl(String? leafletUrl) => _$this._leafletUrl = leafletUrl;

  int? _daysToNextDose;
  int? get daysToNextDose => _$this._daysToNextDose;
  set daysToNextDose(int? daysToNextDose) =>
      _$this._daysToNextDose = daysToNextDose;

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

  VaccineModelBuilder() {
    VaccineModel._initializeBuilder(this);
  }

  VaccineModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _lotNumber = $v.lotNumber;
      _fabricationDate = $v.fabricationDate;
      _dueDate = $v.dueDate;
      _supplier = $v.supplier;
      _producer = $v.producer;
      _leafletUrl = $v.leafletUrl;
      _daysToNextDose = $v.daysToNextDose;
      _ffRef = $v.ffRef;
      _active = $v.active;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VaccineModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$VaccineModel;
  }

  @override
  void update(void Function(VaccineModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VaccineModel build() => _build();

  _$VaccineModel _build() {
    final _$result = _$v ??
        new _$VaccineModel._(
            name: name,
            description: description,
            lotNumber: lotNumber,
            fabricationDate: fabricationDate,
            dueDate: dueDate,
            supplier: supplier,
            producer: producer,
            leafletUrl: leafletUrl,
            daysToNextDose: daysToNextDose,
            ffRef: ffRef,
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'VaccineModel', 'active'),
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
