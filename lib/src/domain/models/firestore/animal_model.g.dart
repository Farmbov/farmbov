// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AnimalModel> _$animalModelSerializer = new _$AnimalModelSerializer();

class _$AnimalModelSerializer implements StructuredSerializer<AnimalModel> {
  @override
  final Iterable<Type> types = const [AnimalModel, _$AnimalModel];
  @override
  final String wireName = 'AnimalModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, AnimalModel object,
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
    value = object.tagNumberRFID;
    if (value != null) {
      result
        ..add('tag_number_rfid')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.tagType;
    if (value != null) {
      result
        ..add('tag_type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.momTagNumber;
    if (value != null) {
      result
        ..add('mom_tag_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.dadTagNumber;
    if (value != null) {
      result
        ..add('dad_tag_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.sex;
    if (value != null) {
      result
        ..add('sex')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.breed;
    if (value != null) {
      result
        ..add('breed')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.entryDate;
    if (value != null) {
      result
        ..add('entry_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.birthDate;
    if (value != null) {
      result
        ..add('birth_date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.lot;
    if (value != null) {
      result
        ..add('lot')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.weight;
    if (value != null) {
      result
        ..add('weight')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.weighingDate;
    if (value != null) {
      result
        ..add('weighing_date')
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
    value = object.photoUrl;
    if (value != null) {
      result
        ..add('photo_url')
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
  AnimalModel deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AnimalModelBuilder();

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
        case 'tag_number_rfid':
          result.tagNumberRFID = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'tag_type':
          result.tagType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'mom_tag_number':
          result.momTagNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'dad_tag_number':
          result.dadTagNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'sex':
          result.sex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'breed':
          result.breed = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'entry_date':
          result.entryDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'birth_date':
          result.birthDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'lot':
          result.lot = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'weight':
          result.weight = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'weighing_date':
          result.weighingDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'notes':
          result.notes = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'photo_url':
          result.photoUrl = serializers.deserialize(value,
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

class _$AnimalModel extends AnimalModel {
  @override
  final String? tagNumber;
  @override
  final String? tagNumberRFID;
  @override
  final String? tagType;
  @override
  final String? momTagNumber;
  @override
  final String? dadTagNumber;
  @override
  final String? sex;
  @override
  final String? breed;
  @override
  final DateTime? entryDate;
  @override
  final DateTime? birthDate;
  @override
  final String? lot;
  @override
  final double? weight;
  @override
  final DateTime? weighingDate;
  @override
  final String? notes;
  @override
  final String? photoUrl;
  @override
  final DocumentReference<Object?>? ffRef;
  @override
  final bool active;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$AnimalModel([void Function(AnimalModelBuilder)? updates]) =>
      (new AnimalModelBuilder()..update(updates))._build();

  _$AnimalModel._(
      {this.tagNumber,
      this.tagNumberRFID,
      this.tagType,
      this.momTagNumber,
      this.dadTagNumber,
      this.sex,
      this.breed,
      this.entryDate,
      this.birthDate,
      this.lot,
      this.weight,
      this.weighingDate,
      this.notes,
      this.photoUrl,
      this.ffRef,
      required this.active,
      this.createdAt,
      this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(active, r'AnimalModel', 'active');
  }

  @override
  AnimalModel rebuild(void Function(AnimalModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnimalModelBuilder toBuilder() => new AnimalModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnimalModel &&
        tagNumber == other.tagNumber &&
        tagNumberRFID == other.tagNumberRFID &&
        tagType == other.tagType &&
        momTagNumber == other.momTagNumber &&
        dadTagNumber == other.dadTagNumber &&
        sex == other.sex &&
        breed == other.breed &&
        entryDate == other.entryDate &&
        birthDate == other.birthDate &&
        lot == other.lot &&
        weight == other.weight &&
        weighingDate == other.weighingDate &&
        notes == other.notes &&
        photoUrl == other.photoUrl &&
        ffRef == other.ffRef &&
        active == other.active &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tagNumber.hashCode);
    _$hash = $jc(_$hash, tagNumberRFID.hashCode);
    _$hash = $jc(_$hash, tagType.hashCode);
    _$hash = $jc(_$hash, momTagNumber.hashCode);
    _$hash = $jc(_$hash, dadTagNumber.hashCode);
    _$hash = $jc(_$hash, sex.hashCode);
    _$hash = $jc(_$hash, breed.hashCode);
    _$hash = $jc(_$hash, entryDate.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jc(_$hash, lot.hashCode);
    _$hash = $jc(_$hash, weight.hashCode);
    _$hash = $jc(_$hash, weighingDate.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, photoUrl.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AnimalModel')
          ..add('tagNumber', tagNumber)
          ..add('tagNumberRFID', tagNumberRFID)
          ..add('tagType', tagType)
          ..add('momTagNumber', momTagNumber)
          ..add('dadTagNumber', dadTagNumber)
          ..add('sex', sex)
          ..add('breed', breed)
          ..add('entryDate', entryDate)
          ..add('birthDate', birthDate)
          ..add('lot', lot)
          ..add('weight', weight)
          ..add('weighingDate', weighingDate)
          ..add('notes', notes)
          ..add('photoUrl', photoUrl)
          ..add('ffRef', ffRef)
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AnimalModelBuilder implements Builder<AnimalModel, AnimalModelBuilder> {
  _$AnimalModel? _$v;

  String? _tagNumber;
  String? get tagNumber => _$this._tagNumber;
  set tagNumber(String? tagNumber) => _$this._tagNumber = tagNumber;

  String? _tagNumberRFID;
  String? get tagNumberRFID => _$this._tagNumberRFID;
  set tagNumberRFID(String? tagNumberRFID) =>
      _$this._tagNumberRFID = tagNumberRFID;

  String? _tagType;
  String? get tagType => _$this._tagType;
  set tagType(String? tagType) => _$this._tagType = tagType;

  String? _momTagNumber;
  String? get momTagNumber => _$this._momTagNumber;
  set momTagNumber(String? momTagNumber) => _$this._momTagNumber = momTagNumber;

  String? _dadTagNumber;
  String? get dadTagNumber => _$this._dadTagNumber;
  set dadTagNumber(String? dadTagNumber) => _$this._dadTagNumber = dadTagNumber;

  String? _sex;
  String? get sex => _$this._sex;
  set sex(String? sex) => _$this._sex = sex;

  String? _breed;
  String? get breed => _$this._breed;
  set breed(String? breed) => _$this._breed = breed;

  DateTime? _entryDate;
  DateTime? get entryDate => _$this._entryDate;
  set entryDate(DateTime? entryDate) => _$this._entryDate = entryDate;

  DateTime? _birthDate;
  DateTime? get birthDate => _$this._birthDate;
  set birthDate(DateTime? birthDate) => _$this._birthDate = birthDate;

  String? _lot;
  String? get lot => _$this._lot;
  set lot(String? lot) => _$this._lot = lot;

  double? _weight;
  double? get weight => _$this._weight;
  set weight(double? weight) => _$this._weight = weight;

  DateTime? _weighingDate;
  DateTime? get weighingDate => _$this._weighingDate;
  set weighingDate(DateTime? weighingDate) =>
      _$this._weighingDate = weighingDate;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  String? _photoUrl;
  String? get photoUrl => _$this._photoUrl;
  set photoUrl(String? photoUrl) => _$this._photoUrl = photoUrl;

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

  AnimalModelBuilder() {
    AnimalModel._initializeBuilder(this);
  }

  AnimalModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tagNumber = $v.tagNumber;
      _tagNumberRFID = $v.tagNumberRFID;
      _tagType = $v.tagType;
      _momTagNumber = $v.momTagNumber;
      _dadTagNumber = $v.dadTagNumber;
      _sex = $v.sex;
      _breed = $v.breed;
      _entryDate = $v.entryDate;
      _birthDate = $v.birthDate;
      _lot = $v.lot;
      _weight = $v.weight;
      _weighingDate = $v.weighingDate;
      _notes = $v.notes;
      _photoUrl = $v.photoUrl;
      _ffRef = $v.ffRef;
      _active = $v.active;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AnimalModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AnimalModel;
  }

  @override
  void update(void Function(AnimalModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnimalModel build() => _build();

  _$AnimalModel _build() {
    final _$result = _$v ??
        new _$AnimalModel._(
            tagNumber: tagNumber,
            tagNumberRFID: tagNumberRFID,
            tagType: tagType,
            momTagNumber: momTagNumber,
            dadTagNumber: dadTagNumber,
            sex: sex,
            breed: breed,
            entryDate: entryDate,
            birthDate: birthDate,
            lot: lot,
            weight: weight,
            weighingDate: weighingDate,
            notes: notes,
            photoUrl: photoUrl,
            ffRef: ffRef,
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'AnimalModel', 'active'),
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
