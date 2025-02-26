import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';

import 'package:farmbov/src/domain/models/firestore/base_model.dart';
import 'package:farmbov/src/domain/models/firestore/serializers.dart';

part 'vaccine_lot_model.g.dart';

abstract class VaccineLotModel
    implements Built<VaccineLotModel, VaccineLotModelBuilder>, BaseModel {
  static Serializer<VaccineLotModel> get serializer =>
      _$vaccineLotModelSerializer;

  @BuiltValueField(wireName: 'vaccine_id')
  String get vaccineId;

  @BuiltValueField(wireName: 'lot_id')
  String get lotId;

  @BuiltValueField(wireName: 'application_date')
  DateTime? get applicationDate;

  String? get notes;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(VaccineLotModelBuilder builder) => builder
    ..vaccineId = ''
    ..lotId = ''
    ..notes = ''
    ..active = true;

  static CollectionReference get collection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('vaccine_lot');
  }

  static Stream<VaccineLotModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<VaccineLotModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  VaccineLotModel._();
  factory VaccineLotModel([void Function(VaccineLotModelBuilder) updates]) =
      _$VaccineLotModel;

  static VaccineLotModel getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createVaccineLotData(
  String vaccineId,
  String lotId, {
  DateTime? applicationDate,
  String? notes,
  required bool create,
}) {
  var model = VaccineLotModel(
    (v) => v
      ..vaccineId = vaccineId
      ..lotId = lotId
      ..applicationDate = applicationDate
      ..notes = notes
      ..updatedAt = getCurrentTimestamp,
  );

  if (create) {
    model = VaccineLotModel(
      (l) => l
        ..vaccineId = vaccineId
        ..lotId = lotId
        ..applicationDate = applicationDate
        ..notes = notes
        ..createdAt = getCurrentTimestamp
        ..updatedAt = getCurrentTimestamp,
    );
  }

  final firestoreData = serializers.toFirestore(
    VaccineLotModel.serializer,
    model,
  );

  return firestoreData;
}
