// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ShareModel> _$shareModelSerializer = new _$ShareModelSerializer();

class _$ShareModelSerializer implements StructuredSerializer<ShareModel> {
  @override
  final Iterable<Type> types = const [ShareModel, _$ShareModel];
  @override
  final String wireName = 'ShareModel';

  @override
  Iterable<Object?> serialize(Serializers serializers, ShareModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'document_or_email',
      serializers.serialize(object.documentOrEmail,
          specifiedType: const FullType(String)),
      'shared_by',
      serializers.serialize(object.sharedBy,
          specifiedType: const FullType(String)),
      'farm_id',
      serializers.serialize(object.farmId,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.sharedTo;
    if (value != null) {
      result
        ..add('shared_to')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.status;
    if (value != null) {
      result
        ..add('status')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
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
    value = object.ffRef;
    if (value != null) {
      result
        ..add('Document__Reference__Field')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  ShareModel deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ShareModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'document_or_email':
          result.documentOrEmail = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'shared_by':
          result.sharedBy = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'shared_to':
          result.sharedTo = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'farm_id':
          result.farmId = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'updated_at':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'Document__Reference__Field':
          result.ffRef = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
      }
    }

    return result.build();
  }
}

class _$ShareModel extends ShareModel {
  @override
  final String documentOrEmail;
  @override
  final String sharedBy;
  @override
  final String? sharedTo;
  @override
  final String farmId;
  @override
  final String? status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$ShareModel([void Function(ShareModelBuilder)? updates]) =>
      (new ShareModelBuilder()..update(updates))._build();

  _$ShareModel._(
      {required this.documentOrEmail,
      required this.sharedBy,
      this.sharedTo,
      required this.farmId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.ffRef})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        documentOrEmail, r'ShareModel', 'documentOrEmail');
    BuiltValueNullFieldError.checkNotNull(sharedBy, r'ShareModel', 'sharedBy');
    BuiltValueNullFieldError.checkNotNull(farmId, r'ShareModel', 'farmId');
  }

  @override
  ShareModel rebuild(void Function(ShareModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShareModelBuilder toBuilder() => new ShareModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShareModel &&
        documentOrEmail == other.documentOrEmail &&
        sharedBy == other.sharedBy &&
        sharedTo == other.sharedTo &&
        farmId == other.farmId &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, documentOrEmail.hashCode);
    _$hash = $jc(_$hash, sharedBy.hashCode);
    _$hash = $jc(_$hash, sharedTo.hashCode);
    _$hash = $jc(_$hash, farmId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShareModel')
          ..add('documentOrEmail', documentOrEmail)
          ..add('sharedBy', sharedBy)
          ..add('sharedTo', sharedTo)
          ..add('farmId', farmId)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class ShareModelBuilder implements Builder<ShareModel, ShareModelBuilder> {
  _$ShareModel? _$v;

  String? _documentOrEmail;
  String? get documentOrEmail => _$this._documentOrEmail;
  set documentOrEmail(String? documentOrEmail) =>
      _$this._documentOrEmail = documentOrEmail;

  String? _sharedBy;
  String? get sharedBy => _$this._sharedBy;
  set sharedBy(String? sharedBy) => _$this._sharedBy = sharedBy;

  String? _sharedTo;
  String? get sharedTo => _$this._sharedTo;
  set sharedTo(String? sharedTo) => _$this._sharedTo = sharedTo;

  String? _farmId;
  String? get farmId => _$this._farmId;
  set farmId(String? farmId) => _$this._farmId = farmId;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  ShareModelBuilder() {
    ShareModel._initializeBuilder(this);
  }

  ShareModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _documentOrEmail = $v.documentOrEmail;
      _sharedBy = $v.sharedBy;
      _sharedTo = $v.sharedTo;
      _farmId = $v.farmId;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShareModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ShareModel;
  }

  @override
  void update(void Function(ShareModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShareModel build() => _build();

  _$ShareModel _build() {
    final _$result = _$v ??
        new _$ShareModel._(
            documentOrEmail: BuiltValueNullFieldError.checkNotNull(
                documentOrEmail, r'ShareModel', 'documentOrEmail'),
            sharedBy: BuiltValueNullFieldError.checkNotNull(
                sharedBy, r'ShareModel', 'sharedBy'),
            sharedTo: sharedTo,
            farmId: BuiltValueNullFieldError.checkNotNull(
                farmId, r'ShareModel', 'farmId'),
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            ffRef: ffRef);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
