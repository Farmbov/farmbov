export 'dart:async' show StreamSubscription;
export 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:collection';

import 'package:farmbov/src/domain/models/firestore/animal_breed_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/domain/models/firestore/area_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_down_model.dart';
import 'package:farmbov/src/domain/models/firestore/farm_model.dart';
import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_handling_model.dart';
import 'package:farmbov/src/domain/models/firestore/serializers.dart';
import 'package:farmbov/src/domain/models/firestore/user_model.dart';
import 'package:farmbov/src/domain/models/firestore/vaccine_lot_model.dart';
import 'package:farmbov/src/domain/models/firestore/vaccine_model.dart';

/// Functions to query Users (as a Stream and as a Future).
Future<int> queryUserCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      UserModel.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<UserModel>> queryUser({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      UserModel.collection,
      UserModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<UserModel>> queryUserOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      UserModel.collection,
      UserModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<FFFirestorePage<UserModel>> queryUserPage({
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) =>
    queryCollectionPage(
      UserModel.collection,
      UserModel.serializer,
      queryBuilder: queryBuilder,
      nextPageMarker: nextPageMarker,
      pageSize: pageSize,
      isStream: isStream,
    );

/// Functions to query FazendaRecords (as a Stream and as a Future).
Future<int> queryFazendaRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      FarmModel.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<FarmModel>> queryFazendaRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      FarmModel.collection,
      FarmModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<FarmModel>> queryFazendaRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      FarmModel.collection,
      FarmModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<FFFirestorePage<FarmModel>> queryFazendaRecordPage({
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) =>
    queryCollectionPage(
      FarmModel.collection,
      FarmModel.serializer,
      queryBuilder: queryBuilder,
      nextPageMarker: nextPageMarker,
      pageSize: pageSize,
      isStream: isStream,
    );

/// Functions to query AreaModels (as a Stream and as a Future).
Future<int> queryAreaModelCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      AreaModel.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<AreaModel>> queryAreaModel({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      AreaModel.collection,
      AreaModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<AreaModel>> queryAreaModelOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      AreaModel.collection,
      AreaModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<FFFirestorePage<AreaModel>> queryAreaModelPage({
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) =>
    queryCollectionPage(
      AreaModel.collection,
      AreaModel.serializer,
      queryBuilder: queryBuilder,
      nextPageMarker: nextPageMarker,
      pageSize: pageSize,
      isStream: isStream,
    );

/// Functions to query LotModels (as a Stream and as a Future).
Future<int> queryLotModelCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      LotModel.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<LotModel>> queryLotModel({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      LotModel.collection,
      LotModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<LotModel>> queryLotModelOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      LotModel.collection,
      LotModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<FFFirestorePage<LotModel>> queryLotModelPage({
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) =>
    queryCollectionPage(
      LotModel.collection,
      LotModel.serializer,
      queryBuilder: queryBuilder,
      nextPageMarker: nextPageMarker,
      pageSize: pageSize,
      isStream: isStream,
    );

/// Functions to query AnimalRecords (as a Stream and as a Future).
Future<int> queryAnimalRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      AnimalModel.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Future<List<AnimalModel>> queryAnimalRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      AnimalModel.collection,
      AnimalModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<FFFirestorePage<AnimalModel>> queryAnimalRecordPage({
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) =>
    queryCollectionPage(
      AnimalModel.collection,
      AnimalModel.serializer,
      queryBuilder: queryBuilder,
      nextPageMarker: nextPageMarker,
      pageSize: pageSize,
      isStream: isStream,
    );

/// Functions to query BaixaAnimalRecords (as a Stream and as a Future).
Future<int> queryBaixaAnimalRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      AnimalDownModel.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<AnimalDownModel>> queryBaixaAnimalRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      AnimalDownModel.collection,
      AnimalDownModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<AnimalDownModel>> queryBaixaAnimalRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      AnimalDownModel.collection,
      AnimalDownModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<FFFirestorePage<AnimalDownModel>> queryBaixaAnimalRecordPage({
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) =>
    queryCollectionPage(
      AnimalDownModel.collection,
      AnimalDownModel.serializer,
      queryBuilder: queryBuilder,
      nextPageMarker: nextPageMarker,
      pageSize: pageSize,
      isStream: isStream,
    );

/// Functions to query Vaccines (as a Stream and as a Future).
Future<int> queryVaccineCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      VaccineModel.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<VaccineModel>> queryVaccine({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      VaccineModel.collection,
      VaccineModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<VaccineModel>> queryVaccineOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      VaccineModel.collection,
      VaccineModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<FFFirestorePage<VaccineModel>> queryVaccinePage({
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) =>
    queryCollectionPage(
      VaccineModel.collection,
      VaccineModel.serializer,
      queryBuilder: queryBuilder,
      nextPageMarker: nextPageMarker,
      pageSize: pageSize,
      isStream: isStream,
    );

Stream<List<AnimalBreedModel>> queryAnimalsBreeds({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      AnimalBreedModel.collection,
      AnimalBreedModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<FFFirestorePage<AnimalBreedModel>> getAnimalsBreeds({
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  int pageSize = 100,
  bool isStream = false,
}) async {
  return queryCollectionPage(
    AnimalBreedModel.collection,
    AnimalBreedModel.serializer,
    queryBuilder: queryBuilder,
    nextPageMarker: nextPageMarker,
    pageSize: pageSize,
    isStream: isStream,
  );
}

Future<List<AnimalBreedModel>> getAnimalsBreedsWithDefault() async {
  List<AnimalBreedModel> list = [];

  final query = await getAnimalsBreeds(
    queryBuilder: (breed) => breed.where('active', isEqualTo: true),
  );

  list.addAll(query.data);

  final uniqueBreeds = HashSet<String>();
  // uniqueBreeds.addAll(defaultAnimalBreeds.map((breed) => breed.name ?? ''));
  uniqueBreeds.addAll(list.map((breed) => breed.name ?? ''));

  List<AnimalBreedModel> mergedList = uniqueBreeds
      .map((breedName) => list.firstWhere(
            (breed) => breed.name == breedName && breed.active == true,
          ))
      .toList();

  mergedList.sort(
    (a, b) => a.name!.compareTo(b.name!),
  );

  return mergedList;
}

/// Functions to query ManejoRecords (as a Stream and as a Future).
Future<int> queryManejoRecordCount({
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) =>
    queryCollectionCount(
      AnimalHandlingModel.collection,
      queryBuilder: queryBuilder,
      limit: limit,
    );

Stream<List<AnimalHandlingModel>> queryManejoRecord({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      AnimalHandlingModel.collection,
      AnimalHandlingModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<AnimalHandlingModel>> queryManejoRecordOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      AnimalHandlingModel.collection,
      AnimalHandlingModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<FFFirestorePage<AnimalHandlingModel>> queryManejoRecordPage({
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) =>
    queryCollectionPage(
      AnimalHandlingModel.collection,
      AnimalHandlingModel.serializer,
      queryBuilder: queryBuilder,
      nextPageMarker: nextPageMarker,
      pageSize: pageSize,
      isStream: isStream,
    );

Future<int> queryCollectionCount(
  Query collection, {
  Query Function(Query)? queryBuilder,
  int limit = -1,
}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0) {
    query = query.limit(limit);
  }

  return query.count().get().catchError((err) {
    print('Error querying $collection: $err');
    return err;
  }).then((value) => value.count ?? 0);
}

Stream<List<VaccineLotModel>> queryVaccineLot({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollection(
      VaccineLotModel.collection,
      VaccineLotModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Future<List<VaccineLotModel>> queryVaccineLotOnce({
  Query Function(Query)? queryBuilder,
  int limit = -1,
  bool singleRecord = false,
}) =>
    queryCollectionOnce(
      VaccineLotModel.collection,
      VaccineLotModel.serializer,
      queryBuilder: queryBuilder,
      limit: limit,
      singleRecord: singleRecord,
    );

Stream<List<T>> queryCollection<T>(Query collection, Serializer<T> serializer,
    {Query Function(Query)? queryBuilder,
    int limit = -1,
    bool singleRecord = false}) {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }
  return query.snapshots().handleError((err) {
    print('Error querying $collection: $err');
  }).map((s) => s.docs
      .map(
        (d) => safeGet(
          () => serializers.deserializeWith(serializer, serializedData(d)),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

Future<List<T>> queryCollectionOnce<T>(
    Query collection, Serializer<T> serializer,
    {Query Function(Query)? queryBuilder,
    int limit = -1,
    bool singleRecord = false}) async {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection);
  if (limit > 0 || singleRecord) {
    query = query.limit(singleRecord ? 1 : limit);
  }

  return query.get().then((s) => s.docs
      .map(
        (d) => safeGet(
          () => serializers.deserializeWith(serializer, serializedData(d)),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList());
}

extension QueryExtension on Query {
  Query whereIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereIn: null)
      : where(field, whereIn: list);

  Query whereNotIn(String field, List? list) => (list?.isEmpty ?? true)
      ? where(field, whereNotIn: null)
      : where(field, whereNotIn: list);

  Query whereArrayContainsAny(String field, List? list) =>
      (list?.isEmpty ?? true)
          ? where(field, arrayContainsAny: null)
          : where(field, arrayContainsAny: list);
}

class FFFirestorePage<T> {
  final List<T> data;
  final Stream<List<T>>? dataStream;
  final QueryDocumentSnapshot? nextPageMarker;

  FFFirestorePage(this.data, this.dataStream, this.nextPageMarker);
}

Future<FFFirestorePage<T>> queryCollectionPage<T>(
  Query collection,
  Serializer<T> serializer, {
  Query Function(Query)? queryBuilder,
  DocumentSnapshot? nextPageMarker,
  required int pageSize,
  required bool isStream,
}) async {
  final builder = queryBuilder ?? (q) => q;
  var query = builder(collection).limit(pageSize);
  if (nextPageMarker != null) {
    query = query.startAfterDocument(nextPageMarker);
  }
  Stream<QuerySnapshot>? docSnapshotStream;
  QuerySnapshot docSnapshot;
  if (isStream) {
    docSnapshotStream = query.snapshots();
    docSnapshot = await docSnapshotStream.first;
  } else {
    docSnapshot = await query.get();
  }
  getDocs(QuerySnapshot s) => s.docs
      .map(
        (d) => safeGet(
          () => serializers.deserializeWith(serializer, serializedData(d)),
          (e) => print('Error serializing doc ${d.reference.path}:\n$e'),
        ),
      )
      .where((d) => d != null)
      .map((d) => d!)
      .toList();
  final data = getDocs(docSnapshot);
  final dataStream = docSnapshotStream?.map(getDocs);
  final nextPageToken = docSnapshot.docs.isEmpty ? null : docSnapshot.docs.last;
  return FFFirestorePage(data, dataStream, nextPageToken);
}

DateTime get getCurrentTimestamp => DateTime.now();
