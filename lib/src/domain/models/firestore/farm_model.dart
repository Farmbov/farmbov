import 'dart:async';

import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/base_model.dart';
import 'package:built_value/built_value.dart';

import 'package:farmbov/src/domain/models/firestore/serializers.dart';

part 'farm_model.g.dart';

abstract class FarmModel
    implements Built<FarmModel, FarmModelBuilder>, BaseModel {
  static Serializer<FarmModel> get serializer => _$farmModelSerializer;

  @BuiltValueField(wireName: 'owner_id')
  String? get ownerId;

  String? get name;

  double? get area;

  String? get latitude;

  String? get longitude;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(FarmModelBuilder builder) => builder
    ..ownerId = ''
    ..name = ''
    ..area = 0.0
    ..latitude = ''
    ..longitude = ''
    ..active = true;

  static CollectionReference get collection {
    return FirebaseFirestore.instance.collection('farms');
  }

  static Stream<FarmModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<FarmModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  FarmModel._();
  factory FarmModel([void Function(FarmModelBuilder) updates]) = _$FarmModel;

  static FarmModel getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createFarmData({
  String? ownerId,
  String? name,
  double? area,
  String? latitude,
  String? longitude,
  required bool create,
}) {
  var model = FarmModel(
    (f) => f
      ..ownerId = ownerId
      ..name = name
      ..area = area
      ..latitude = latitude
      ..longitude = longitude
      ..updatedAt = getCurrentTimestamp,
  );

  if (create) {
    model = FarmModel(
      (l) => l
        ..ownerId = ownerId
        ..name = name
        ..area = area
        ..latitude = latitude
        ..longitude = longitude
        ..createdAt = getCurrentTimestamp
        ..updatedAt = getCurrentTimestamp,
    );
  }

  final firestoreData = serializers.toFirestore(
    FarmModel.serializer,
    model,
  );

  return firestoreData;
}
