import 'dart:async';

import 'package:farmbov/src/domain/constants/share_farm_status.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';

import 'package:farmbov/src/domain/models/firestore/serializers.dart';
import 'package:built_value/built_value.dart';

part 'share_model.g.dart';

abstract class ShareModel implements Built<ShareModel, ShareModelBuilder> {
  static Serializer<ShareModel> get serializer => _$shareModelSerializer;

  @BuiltValueField(wireName: 'document_or_email')
  String get documentOrEmail;

  @BuiltValueField(wireName: 'shared_by')
  String get sharedBy;

  @BuiltValueField(wireName: 'shared_to')
  String? get sharedTo;

  @BuiltValueField(wireName: 'farm_id')
  String get farmId;

  String? get status;

  @BuiltValueField(wireName: 'created_at')
  DateTime? get createdAt;
  @BuiltValueField(wireName: 'updated_at')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(ShareModelBuilder builder) => builder
    ..documentOrEmail = ''
    ..sharedBy = ''
    ..sharedTo = ''
    ..farmId = ''
    ..status = ShareFarmStatus.pending.toMap();

  static CollectionReference get collection {
    return FirebaseFirestore.instance.collection('shares');
  }

  static Stream<ShareModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<ShareModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  ShareModel._();
  factory ShareModel([void Function(ShareModelBuilder) updates]) = _$ShareModel;

  static ShareModel getDocumentFromData(Map<String, dynamic> data,
          {DocumentReference? reference}) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createShareModelData({
  required String farmId,
  String? documentOrEmail,
  String? sharedBy,
  String? sharedTo,
  required bool create,
}) {
  var model = ShareModel(
    (a) => a
      ..documentOrEmail = documentOrEmail
      ..sharedBy = sharedBy
      ..sharedTo = sharedTo
      ..farmId = farmId
      ..updatedAt = getCurrentTimestamp,
  );

  if (create) {
    model = ShareModel(
      (a) => a
        ..documentOrEmail = documentOrEmail
        ..sharedBy = sharedBy
        ..sharedTo = sharedTo
        ..farmId = farmId
        ..status = ShareFarmStatus.pending.toMap()
        ..createdAt = getCurrentTimestamp
        ..updatedAt = getCurrentTimestamp,
    );
  }

  final firestoreData = serializers.toFirestore(
    ShareModel.serializer,
    model,
  );

  return firestoreData;
}
