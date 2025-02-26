import 'dart:async';

import 'package:built_value/built_value.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/base_model.dart';

import 'package:farmbov/src/domain/models/firestore/serializers.dart';

part 'user_model.g.dart';

// @freezed
// TODO: generate copywith with freezed
abstract class UserModel
    implements Built<UserModel, UserModelBuilder>, BaseModel {
  static Serializer<UserModel> get serializer => _$userModelSerializer;

  @BuiltValueField(wireName: 'full_name')
  String? get fullName;

  String? get document;

  @BuiltValueField(wireName: 'photo_url')
  String? get photoUrl;

  String? get email;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  String? get zipCode;

  String? get address;

  String? get complement;

  String? get neighborhood;

  String? get city;

  String? get state;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(UserModelBuilder builder) => builder
    ..fullName = ''
    ..document = ''
    ..photoUrl = ''
    ..email = ''
    ..phoneNumber = ''
    ..zipCode = ''
    ..address = ''
    ..complement = ''
    ..neighborhood = ''
    ..city = ''
    ..state = ''
    ..active = true;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UserModel> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<UserModel> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  UserModel._();
  factory UserModel([void Function(UserModelBuilder) updates]) = _$UserModel;

  static UserModel getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  @override
  Map<String, dynamic>? toMap() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>?;
}

Map<String, dynamic> createUserData({
  String? fullName,
  String? document,
  String? photoUrl,
  String? email,
  String? phoneNumber,
  String? zipCode,
  String? address,
  String? complement,
  String? neighborhood,
  String? city,
  String? state,
  required bool create,
}) {
  var model = UserModel(
    (u) => u
      ..fullName = fullName
      ..document = document
      ..photoUrl = photoUrl
      ..email = email
      ..phoneNumber = phoneNumber
      ..zipCode = zipCode
      ..address = address
      ..complement = complement
      ..neighborhood = neighborhood
      ..city = city
      ..state = state
      ..updatedAt = getCurrentTimestamp,
  );

  if (create) {
    model = UserModel(
      (u) => u
        ..fullName = fullName
        ..document = document
        ..photoUrl = photoUrl
        ..email = email
        ..phoneNumber = phoneNumber
        ..zipCode = zipCode
        ..address = address
        ..complement = complement
        ..neighborhood = neighborhood
        ..city = city
        ..state = state
        ..createdAt = getCurrentTimestamp
        ..updatedAt = getCurrentTimestamp,
    );
  }

  final firestoreData = serializers.toFirestore(UserModel.serializer, model);

  return firestoreData;
}
