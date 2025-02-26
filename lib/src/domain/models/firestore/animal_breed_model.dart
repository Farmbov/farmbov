import 'dart:async';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/models/firestore/base_model.dart';
import 'package:farmbov/src/domain/models/firestore/serializers.dart';

import 'package:built_value/built_value.dart';

part 'animal_breed_model.g.dart';

abstract class AnimalBreedModel
    implements Built<AnimalBreedModel, AnimalBreedModelBuilder>, BaseModel {
  static Serializer<AnimalBreedModel> get serializer =>
      _$animalBreedModelSerializer;

  String? get name;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(AnimalBreedModelBuilder builder) => builder
    ..name = ''
    ..active = true;

  static CollectionReference get collection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('animal_breeds');
  }

  static Stream<AnimalBreedModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<AnimalBreedModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  AnimalBreedModel._();
  factory AnimalBreedModel([void Function(AnimalBreedModelBuilder) updates]) =
      _$AnimalBreedModel;

  static AnimalBreedModel getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createAnimalBreedModel({
  String? name,
  bool active = true,
}) {
  final firestoreData = serializers.toFirestore(
    AnimalBreedModel.serializer,
    AnimalBreedModel(
      (b) => b
        ..name = name
        ..active = active,
    ),
  );

  return firestoreData;
}
