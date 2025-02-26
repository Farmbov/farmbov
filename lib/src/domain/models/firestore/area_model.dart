import 'dart:async';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/base_model.dart';

import 'package:farmbov/src/domain/models/firestore/serializers.dart';
import 'package:built_value/built_value.dart';

part 'area_model.g.dart';

abstract class AreaModel
    implements Built<AreaModel, AreaModelBuilder>, BaseModel {
  static Serializer<AreaModel> get serializer => _$areaModelSerializer;

  String? get name;

  double? get totalArea;

  int? get animalsLotsAmount;

  int? get totalCapacity;

  @BuiltValueField(wireName: 'use_type')
  String? get usageType;

  String? get notes;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(AreaModelBuilder builder) => builder
    ..name = ''
    ..totalArea = 0
    ..notes = ''
    ..animalsLotsAmount = 0
    ..active = true;

  static CollectionReference get collection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('areas');
  }

  static Stream<AreaModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<AreaModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  AreaModel._();
  factory AreaModel([void Function(AreaModelBuilder) updates]) = _$AreaModel;

  static AreaModel getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createAreaModelData({
  String? name,
  double? totalArea,
  int? animalsLotsAmount,
  int? totalCapacity,
  String? usageType,
  String? notes,
  required bool create,
}) {
  var model = AreaModel(
    (a) => a
      ..name = name
      ..totalArea = totalArea
      ..animalsLotsAmount = animalsLotsAmount
      ..totalCapacity = totalCapacity
      ..usageType = usageType
      ..notes = notes
      ..updatedAt = getCurrentTimestamp,
  );

  if (create) {
    model = AreaModel(
      (a) => a
        ..name = name
        ..totalArea = totalArea
        ..animalsLotsAmount = animalsLotsAmount
        ..totalCapacity = totalCapacity
        ..usageType = usageType
        ..notes = notes
        ..createdAt = getCurrentTimestamp
        ..updatedAt = getCurrentTimestamp,
    );
  }

  final firestoreData = serializers.toFirestore(AreaModel.serializer, model);

  return firestoreData;
}
