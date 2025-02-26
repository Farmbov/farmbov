import 'dart:async';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/base_model.dart';
import 'package:farmbov/src/domain/models/firestore/serializers.dart';
import 'package:built_value/built_value.dart';

part 'lot_model.g.dart';

abstract class LotModel implements Built<LotModel, LotModelBuilder>, BaseModel {
  static Serializer<LotModel> get serializer => _$lotModelSerializer;

  String? get area;

  String? get name;

  int? get animalsCapacity;

  String? get notes;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(LotModelBuilder builder) => builder
    ..name = ''
    ..area = ''
    ..animalsCapacity = 0
    ..notes = ''
    ..active = true;

  static CollectionReference get collection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('lots');
  }

  static Stream<LotModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<LotModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  LotModel._();
  factory LotModel([void Function(LotModelBuilder) updates]) = _$LotModel;

  static LotModel getDocumentFromData(Map<String, dynamic> data,
          {DocumentReference? reference}) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createLotModelData({
  String? name,
  String? area,
  int? animalsCapacity,
  String? notes,
  required bool create,
}) {
  var model = LotModel(
    (l) => l
      ..name = name
      ..area = area
      ..animalsCapacity = animalsCapacity
      ..notes = notes
      ..updatedAt = getCurrentTimestamp,
  );

  if (create) {
    model = LotModel(
      (l) => l
        ..name = name
        ..area = area
        ..animalsCapacity = animalsCapacity
        ..notes = notes
        ..createdAt = getCurrentTimestamp
        ..updatedAt = getCurrentTimestamp,
    );
  }

  final firestoreData = serializers.toFirestore(LotModel.serializer, model);

  return firestoreData;
}
