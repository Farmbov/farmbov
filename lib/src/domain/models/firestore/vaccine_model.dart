import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';

import 'package:farmbov/src/domain/models/firestore/base_model.dart';
import 'package:farmbov/src/domain/models/firestore/serializers.dart';

part 'vaccine_model.g.dart';

abstract class VaccineModel
    implements Built<VaccineModel, VaccineModelBuilder>, BaseModel {
  static Serializer<VaccineModel> get serializer => _$vaccineModelSerializer;

  String? get name;

  String? get description;

  @BuiltValueField(wireName: 'lot_number')
  String? get lotNumber;

  @BuiltValueField(wireName: 'fabrication_date')
  DateTime? get fabricationDate;

  @BuiltValueField(wireName: 'due_date')
  DateTime? get dueDate;

  String? get supplier;

  String? get producer;

  @BuiltValueField(wireName: 'leaflet_url')
  String? get leafletUrl;

  @BuiltValueField(wireName: 'days_to_next_dose')
  int? get daysToNextDose;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(VaccineModelBuilder builder) => builder
    ..name = ''
    ..description = ''
    ..lotNumber = ''
    ..supplier = ''
    ..producer = ''
    ..leafletUrl = ''
    ..active = true;

  static CollectionReference get collection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('vaccines');
  }

  static Stream<VaccineModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<VaccineModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  VaccineModel._();
  factory VaccineModel([void Function(VaccineModelBuilder) updates]) =
      _$VaccineModel;

  static VaccineModel getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createVaccineData({
  String? name,
  String? description,
  String? lotNumber,
  DateTime? fabricationDate,
  DateTime? dueDate,
  String? supplier,
  String? producer,
  String? leafletUrl,
  int? daysToNextDose,
  required bool create,
}) {
  var model = VaccineModel(
    (v) => v
      ..name = name
      ..description = description
      ..lotNumber = lotNumber
      ..fabricationDate = fabricationDate
      ..dueDate = dueDate
      ..supplier = supplier
      ..producer = producer
      ..leafletUrl = leafletUrl
      ..daysToNextDose = daysToNextDose
      ..updatedAt = getCurrentTimestamp,
  );

  if (create) {
    model = VaccineModel(
      (l) => l
        ..name = name
        ..description = description
        ..lotNumber = lotNumber
        ..fabricationDate = fabricationDate
        ..dueDate = dueDate
        ..supplier = supplier
        ..producer = producer
        ..leafletUrl = leafletUrl
        ..daysToNextDose = daysToNextDose
        ..createdAt = getCurrentTimestamp
        ..updatedAt = getCurrentTimestamp,
    );
  }

  final firestoreData = serializers.toFirestore(
    VaccineModel.serializer,
    model,
  );

  return firestoreData;
}
