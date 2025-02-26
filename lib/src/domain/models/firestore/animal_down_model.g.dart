// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_down_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AnimalDownModel> _$animalDownModelSerializer =
    new _$AnimalDownModelSerializer();

class _$AnimalDownModelSerializer
    implements StructuredSerializer<AnimalDownModel> {
  @override
  final Iterable<Type> types = const [AnimalDownModel, _$AnimalDownModel];
  @override
  final String wireName = 'AnimalDownModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, AnimalDownModel object,
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
    value = object.downReason;
    if (value != null) {
      result
        ..add('down_reason')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.downDate;
    if (value != null) {
      result
        ..add('down_date')
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
  AnimalDownModel deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AnimalDownModelBuilder();

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
        case 'down_reason':
          result.downReason = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'down_date':
          result.downDate = serializers.deserialize(value,
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

class _$AnimalDownModel extends AnimalDownModel {
  @override
  final String? tagNumber;
  @override
  final String? downReason;
  @override
  final DateTime? downDate;
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

  factory _$AnimalDownModel([void Function(AnimalDownModelBuilder)? updates]) =>
      (new AnimalDownModelBuilder()..update(updates))._build();

  _$AnimalDownModel._(
      {this.tagNumber,
      this.downReason,
      this.downDate,
      this.notes,
      this.ffRef,
      required this.active,
      this.createdAt,
      this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(active, r'AnimalDownModel', 'active');
  }

  @override
  AnimalDownModel rebuild(void Function(AnimalDownModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnimalDownModelBuilder toBuilder() =>
      new AnimalDownModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AnimalDownModel &&
        tagNumber == other.tagNumber &&
        downReason == other.downReason &&
        downDate == other.downDate &&
        notes == other.notes &&
        ffRef == other.ffRef &&
        active == other.active &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tagNumber.hashCode);
    _$hash = $jc(_$hash, downReason.hashCode);
    _$hash = $jc(_$hash, downDate.hashCode);
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
    return (newBuiltValueToStringHelper(r'AnimalDownModel')
          ..add('tagNumber', tagNumber)
          ..add('downReason', downReason)
          ..add('downDate', downDate)
          ..add('notes', notes)
          ..add('ffRef', ffRef)
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AnimalDownModelBuilder
    implements Builder<AnimalDownModel, AnimalDownModelBuilder> {
  _$AnimalDownModel? _$v;

  String? _tagNumber;
  String? get tagNumber => _$this._tagNumber;
  set tagNumber(String? tagNumber) => _$this._tagNumber = tagNumber;

  String? _downReason;
  String? get downReason => _$this._downReason;
  set downReason(String? downReason) => _$this._downReason = downReason;

  DateTime? _downDate;
  DateTime? get downDate => _$this._downDate;
  set downDate(DateTime? downDate) => _$this._downDate = downDate;

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

  AnimalDownModelBuilder() {
    AnimalDownModel._initializeBuilder(this);
  }

  AnimalDownModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tagNumber = $v.tagNumber;
      _downReason = $v.downReason;
      _downDate = $v.downDate;
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
  void replace(AnimalDownModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AnimalDownModel;
  }

  @override
  void update(void Function(AnimalDownModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AnimalDownModel build() => _build();

  _$AnimalDownModel _build() {
    final _$result = _$v ??
        new _$AnimalDownModel._(
            tagNumber: tagNumber,
            downReason: downReason,
            downDate: downDate,
            notes: notes,
            ffRef: ffRef,
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'AnimalDownModel', 'active'),
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
