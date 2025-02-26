import 'dart:async';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/base_model.dart';
import 'package:farmbov/src/domain/models/firestore/serializers.dart';
import 'package:built_value/built_value.dart';

part 'animal_model.g.dart';

abstract class AnimalModel
    implements Built<AnimalModel, AnimalModelBuilder>, BaseModel {
  static Serializer<AnimalModel> get serializer => _$animalModelSerializer;

  @BuiltValueField(wireName: 'tag_number')
  String? get tagNumber;

  @BuiltValueField(wireName: 'tag_number_rfid')
  String? get tagNumberRFID;

  @BuiltValueField(wireName: 'tag_type')
  String? get tagType;

  @BuiltValueField(wireName: 'mom_tag_number')
  String? get momTagNumber;

  @BuiltValueField(wireName: 'dad_tag_number')
  String? get dadTagNumber;

  String? get sex;

  String? get breed;

  @BuiltValueField(wireName: 'entry_date')
  DateTime? get entryDate;

  @BuiltValueField(wireName: 'birth_date')
  DateTime? get birthDate;

  String? get lot;

  double? get weight;

  @BuiltValueField(wireName: 'weighing_date')
  DateTime? get weighingDate;

  String? get notes;

  @BuiltValueField(wireName: 'photo_url')
  String? get photoUrl;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(AnimalModelBuilder builder) => builder
    ..tagNumber = ''
    ..tagNumberRFID = ''
    ..tagType = ''
    ..momTagNumber = ''
    ..dadTagNumber = ''
    ..sex = ''
    ..breed = ''
    ..lot = ''
    ..weight = 0.0
    ..notes = ''
    ..photoUrl = ''
    ..active = true;

  static CollectionReference get collection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('animals');
  }

  static Stream<AnimalModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<AnimalModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  AnimalModel._();
  factory AnimalModel([void Function(AnimalModelBuilder) updates]) =
      _$AnimalModel;

  static AnimalModel getDocumentFromData(Map<String, dynamic> data,
          {DocumentReference? reference}) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createAnimalModelData({
  String? tagNumber,
  String? tagNumberRFID,
  String? tagType,
  String? momTagNumber,
  String? dadTagNumber,
  String? sex,
  String? breed,
  DateTime? entryDate,
  DateTime? birthDate,
  String? lot,
  double? weight,
  DateTime? weighingDate,
  String? notes,
  String? photoUrl,
  bool active = true,
  required bool create,
}) {
  var model = AnimalModel(
    (a) => a
      ..tagNumber = tagNumber
      ..tagNumberRFID = tagNumberRFID
      ..tagType = tagType
      ..momTagNumber = momTagNumber
      ..dadTagNumber = dadTagNumber
      ..sex = sex
      ..breed = breed
      ..entryDate = entryDate
      ..birthDate = birthDate
      ..lot = lot
      ..weight = weight
      ..weighingDate = weighingDate
      ..notes = notes
      ..photoUrl = photoUrl
      ..active = active
      ..updatedAt = getCurrentTimestamp,
  );

  if (create) {
    model = AnimalModel(
      (a) => a
        ..tagNumber = tagNumber
        ..tagNumberRFID = tagNumberRFID
        ..tagType = tagType
        ..momTagNumber = momTagNumber
        ..dadTagNumber = dadTagNumber
        ..sex = sex
        ..breed = breed
        ..entryDate = entryDate
        ..birthDate = birthDate
        ..lot = lot
        ..weight = weight
        ..weighingDate = weighingDate
        ..notes = notes
        ..photoUrl = photoUrl
        ..active = active
        ..createdAt = getCurrentTimestamp
        ..updatedAt = getCurrentTimestamp,
    );
  }

  final firestoreData = serializers.toFirestore(AnimalModel.serializer, model);

  return firestoreData;
}
