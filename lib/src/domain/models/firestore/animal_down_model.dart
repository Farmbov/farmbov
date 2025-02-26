import 'dart:async';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/models/firestore/base_model.dart';
import 'package:farmbov/src/domain/models/firestore/serializers.dart';

import 'package:built_value/built_value.dart';

part 'animal_down_model.g.dart';

abstract class AnimalDownModel
    implements Built<AnimalDownModel, AnimalDownModelBuilder>, BaseModel {
  static Serializer<AnimalDownModel> get serializer =>
      _$animalDownModelSerializer;

  @BuiltValueField(wireName: 'tag_number')
  String? get tagNumber;

  @BuiltValueField(wireName: 'down_reason')
  String? get downReason;

  @BuiltValueField(wireName: 'down_date')
  DateTime? get downDate;

  String? get notes;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(AnimalDownModelBuilder builder) => builder
    ..tagNumber = ''
    ..downReason = ''
    ..notes = ''
    ..active = true;

  static CollectionReference get collection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('animals_down');
  }

  static Stream<AnimalDownModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<AnimalDownModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  AnimalDownModel._();
  factory AnimalDownModel([void Function(AnimalDownModelBuilder) updates]) =
      _$AnimalDownModel;

  static AnimalDownModel getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createBaixaAnimalRecordData({
  String? tagNumber,
  String? downReason,
  DateTime? downDate,
  String? notes,
}) {
  final firestoreData = serializers.toFirestore(
    AnimalDownModel.serializer,
    AnimalDownModel(
      (b) => b
        ..tagNumber = tagNumber
        ..downReason = downReason
        ..downDate = downDate
        ..notes = notes,
    ),
  );

  return firestoreData;
}
