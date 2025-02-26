import 'dart:async';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/models/firestore/base_model.dart';
import 'package:farmbov/src/domain/models/firestore/serializers.dart';

import 'package:built_value/built_value.dart';

part 'animal_handling_model.g.dart';

abstract class AnimalHandlingModel
    implements
        Built<AnimalHandlingModel, AnimalHandlingModelBuilder>,
        BaseModel {
  static Serializer<AnimalHandlingModel> get serializer =>
      _$animalHandlingModelSerializer;

  @BuiltValueField(wireName: 'tag_number')
  String? get tagNumber;

  @BuiltValueField(wireName: 'male_tag_number')
  String? get maleTagNumber;

  @BuiltValueField(wireName: 'handling_type')
  String? get handlingType;

  @BuiltValueField(wireName: 'handling_date')
  DateTime? get handlingDate;

  @BuiltValueField(wireName: 'pregnant_date')
  DateTime? get pregnantDate;

  @BuiltValueField(wireName: 'vaccine')
  String? get vaccine;

  @BuiltValueField(wireName: 'batch_number')
  String? get batchNumber;

  String? get weight;

  bool? get isPregnant;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(AnimalHandlingModelBuilder builder) => builder
    ..tagNumber = ''
    ..maleTagNumber = ''
    ..handlingType = ''
    ..weight = ''
    ..isPregnant = false
    ..vaccine = ''
    ..batchNumber = ''
    ..active = true;

  static CollectionReference get collection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('animals_handlings');
  }

  static Stream<AnimalHandlingModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<AnimalHandlingModel> getDocumentOnce(DocumentReference ref) =>
      ref.get().then(
          (s) => serializers.deserializeWith(serializer, serializedData(s))!);

  AnimalHandlingModel._();
  factory AnimalHandlingModel(
          [void Function(AnimalHandlingModelBuilder) updates]) =
      _$AnimalHandlingModel;

  static AnimalHandlingModel getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createManejoRecordData({
  String? tagNumber,
  String? handlingType,
  DateTime? handlingDate,
  DateTime? pregnantDate,
  String? weight,
  bool? isPregnant,
  String? vaccine,
  String? batchNumber,
}) {
  final firestoreData = serializers.toFirestore(
    AnimalHandlingModel.serializer,
    AnimalHandlingModel((m) => m
      ..tagNumber = tagNumber
      ..handlingType = handlingType
      ..handlingDate = handlingDate
      ..pregnantDate = pregnantDate
      ..weight = weight
      ..isPregnant = isPregnant
      ..vaccine = vaccine
      ..batchNumber = batchNumber),
  );

  return firestoreData;
}
