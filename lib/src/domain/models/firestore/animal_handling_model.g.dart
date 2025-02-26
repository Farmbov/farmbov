// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_handling_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AnimalHandlingModel> _$animalHandlingModelSerializer =
    new _$AnimalHandlingModelSerializer();

class _$AnimalHandlingModelSerializer
    implements StructuredSerializer<AnimalHandlingModel> {
  @override
  final Iterable<Type> types = const [
    AnimalHandlingModel,
    _$AnimalHandlingModel
  ];
  @override
  final String wireName = 'AnimalHandlingModel';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, AnimalHandlingModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'active',
      serializers.serialize(object.active, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.tagNumber;
    if (value != null) {
      result
        ..add('tag_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.maleTagNumber;
    if (value != null) {
      result
        ..add('male_tag_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.handlingType;
    if (value != null) {
      result
        ..add('handling_type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.handlingDate;
    if (value != null) {
      result
        ..add('handling_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.pregnantDate;
    if (value != null) {
      result
        ..add('pregnant_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.vaccine;
    if (value != null) {
      result
        ..add('vaccine')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.batchNumber;
    if (value != null) {
      result
        ..add('batch_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.weight;
    if (value != null) {
      result
        ..add('weight')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.isPregnant;
    if (value != null) {
      result
        ..add('isPregnant')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
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
  AnimalHandlingModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AnimalHandlingModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'tag_number':
          result.tagNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'male_tag_number':
          result.maleTagNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'handling_type':
          result.handlingType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'handling_date':
          result.handlingDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'pregnant_date':
          result.pregnantDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'vaccine':
          result.vaccine = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'batch_number':
          result.batchNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'weight':
          result.weight = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'isPregnant':
          result.isPregnant = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
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

class _$AnimalHandlingModel extends AnimalHandlingModel {
  @override
  final String? tagNumber;
  @override
  final String? maleTagNumber;
  @override
  final String? handlingType;
  @override
  final DateTime? handlingDate;
  @override
  final DateTime? pregnantDate;
  @override
  final String? vaccine;
  @override
  final String? batchNumber;
  @override
  final String? weight;
  @override
  final bool? isPregnant;
  @override
  final DocumentReference<Object?>? ffRef;
  @override
  final bool active;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$AnimalHandlingModel(
          [void Function(AnimalHandlingModelBuilder)? updates]) =>
      (new AnimalHandlingModelBuilder()..update(updates))._build();

  _$AnimalHandlingModel._(
      {this.tagNumber,
      this.maleTagNumber,
      this.handlingType,
      this.handlingDate,
      this.pregnantDate,
      this.vaccine,
      this.batchNumber,
      this.weight,
      this.isPregnant,
      this.ffRef,
      required this.active,
      this.createdAt,
      this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        active, r'AnimalHandlingModel', 'active');
  }

  @override
  AnimalHandlingModel rebuild(
          void Function(AnimalHandlingModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnimalHandlingModelBuilder toBuilder() =>
      new AnimalHandlingModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnimalHandlingModel &&
        tagNumber == other.tagNumber &&
        maleTagNumber == other.maleTagNumber &&
        handlingType == other.handlingType &&
        handlingDate == other.handlingDate &&
        pregnantDate == other.pregnantDate &&
        vaccine == other.vaccine &&
        batchNumber == other.batchNumber &&
        weight == other.weight &&
        isPregnant == other.isPregnant &&
        ffRef == other.ffRef &&
        active == other.active &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tagNumber.hashCode);
    _$hash = $jc(_$hash, maleTagNumber.hashCode);
    _$hash = $jc(_$hash, handlingType.hashCode);
    _$hash = $jc(_$hash, handlingDate.hashCode);
    _$hash = $jc(_$hash, pregnantDate.hashCode);
    _$hash = $jc(_$hash, vaccine.hashCode);
    _$hash = $jc(_$hash, batchNumber.hashCode);
    _$hash = $jc(_$hash, weight.hashCode);
    _$hash = $jc(_$hash, isPregnant.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnimalHandlingModel')
          ..add('tagNumber', tagNumber)
          ..add('maleTagNumber', maleTagNumber)
          ..add('handlingType', handlingType)
          ..add('handlingDate', handlingDate)
          ..add('pregnantDate', pregnantDate)
          ..add('vaccine', vaccine)
          ..add('batchNumber', batchNumber)
          ..add('weight', weight)
          ..add('isPregnant', isPregnant)
          ..add('ffRef', ffRef)
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AnimalHandlingModelBuilder
    implements Builder<AnimalHandlingModel, AnimalHandlingModelBuilder> {
  _$AnimalHandlingModel? _$v;

  String? _tagNumber;
  String? get tagNumber => _$this._tagNumber;
  set tagNumber(String? tagNumber) => _$this._tagNumber = tagNumber;

  String? _maleTagNumber;
  String? get maleTagNumber => _$this._maleTagNumber;
  set maleTagNumber(String? maleTagNumber) =>
      _$this._maleTagNumber = maleTagNumber;

  String? _handlingType;
  String? get handlingType => _$this._handlingType;
  set handlingType(String? handlingType) => _$this._handlingType = handlingType;

  DateTime? _handlingDate;
  DateTime? get handlingDate => _$this._handlingDate;
  set handlingDate(DateTime? handlingDate) =>
      _$this._handlingDate = handlingDate;

  DateTime? _pregnantDate;
  DateTime? get pregnantDate => _$this._pregnantDate;
  set pregnantDate(DateTime? pregnantDate) =>
      _$this._pregnantDate = pregnantDate;

  String? _vaccine;
  String? get vaccine => _$this._vaccine;
  set vaccine(String? vaccine) => _$this._vaccine = vaccine;

  String? _batchNumber;
  String? get batchNumber => _$this._batchNumber;
  set batchNumber(String? batchNumber) => _$this._batchNumber = batchNumber;

  String? _weight;
  String? get weight => _$this._weight;
  set weight(String? weight) => _$this._weight = weight;

  bool? _isPregnant;
  bool? get isPregnant => _$this._isPregnant;
  set isPregnant(bool? isPregnant) => _$this._isPregnant = isPregnant;

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

  AnimalHandlingModelBuilder() {
    AnimalHandlingModel._initializeBuilder(this);
  }

  AnimalHandlingModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tagNumber = $v.tagNumber;
      _maleTagNumber = $v.maleTagNumber;
      _handlingType = $v.handlingType;
      _handlingDate = $v.handlingDate;
      _pregnantDate = $v.pregnantDate;
      _vaccine = $v.vaccine;
      _batchNumber = $v.batchNumber;
      _weight = $v.weight;
      _isPregnant = $v.isPregnant;
      _ffRef = $v.ffRef;
      _active = $v.active;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnimalHandlingModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AnimalHandlingModel;
  }

  @override
  void update(void Function(AnimalHandlingModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnimalHandlingModel build() => _build();

  _$AnimalHandlingModel _build() {
    final _$result = _$v ??
        new _$AnimalHandlingModel._(
            tagNumber: tagNumber,
            maleTagNumber: maleTagNumber,
            handlingType: handlingType,
            handlingDate: handlingDate,
            pregnantDate: pregnantDate,
            vaccine: vaccine,
            batchNumber: batchNumber,
            weight: weight,
            isPregnant: isPregnant,
            ffRef: ffRef,
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'AnimalHandlingModel', 'active'),
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
