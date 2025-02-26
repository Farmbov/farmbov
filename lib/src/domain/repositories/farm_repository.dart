import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/domain/models/firestore/farm_model.dart';
import 'package:farmbov/src/domain/models/firestore/share_model.dart';

abstract class FarmRepository {
  //Future<List<FarmModel>> getFarms();
  Future<FarmModel?> getFarmById(String id);
  Future<void> addFarm(FarmModel farm);
  Future<void> updateFarm(FarmModel farm);
  Future<void> deleteFarm(String id);
  Future<List<FarmModel>> getSharedFarmsToUser(String userId);
  Future<List<ShareModel>> getSharedUsers(String? farmId);
}

class FarmRepositoryImpl implements FarmRepository {
  final CollectionReference _sharesCollection =
      FirebaseFirestore.instance.collection('shares');

  final CollectionReference _farmCollection =
      FirebaseFirestore.instance.collection('farms');

  // @override
  // Future<List<FarmModel>> getFarms() async {
  //   QuerySnapshot snapshot = await _farmCollection.get();
  //   List<FarmModel> farms =
  //       snapshot.docs.map((doc) => FarmModel.frzzzz(doc)).toList();
  //   return farms;
  // }

  @override
  Future<FarmModel?> getFarmById(String id) async {
    final farm = await _farmCollection.doc(id).get();
    if (farm.exists) {
      return FarmModel.getDocumentFromData(
          farm.data() as Map<String, dynamic>, farm.reference);
    }
    return null;
  }

  @override
  Future<void> addFarm(FarmModel farm) async {
    await _farmCollection.add(farm.toMap());
  }

  @override
  Future<void> updateFarm(FarmModel farm) async {
    //sawait _farmCollection.doc(farm.id).update(farm.toMap());
  }

  @override
  Future<void> deleteFarm(String id) async {
    await _farmCollection.doc(id).delete();
  }

  @override
  Future<List<FarmModel>> getSharedFarmsToUser(String userId) async {
    if (userId.isEmpty) return [];

    // Obtém os documentos que correspondem ao campo 'shared_to' com o userId
    final sharesResult =
        await _sharesCollection.where('shared_to', isEqualTo: userId).get();

    // Mapeia os shares para obter os farmIds e busca cada fazenda correspondente
    final shares = sharesResult.docs
        .map((e) =>
            ShareModel.getDocumentFromData(e.data() as Map<String, dynamic>))
        .toList();

    final farms = <FarmModel>[];

    for (String id in shares.map((e) => e.farmId)) {
      final farm = await getFarmById(id);
      if (farm != null) {
        farms.add(farm);
      }
    }

    // Busca as fazendas onde o userId é o proprietário
    final userFarms =
        await _farmCollection.where('owner_id', isEqualTo: userId).get();

    farms.addAll(userFarms.docs.map((e) => FarmModel.getDocumentFromData(
        e.data() as Map<String, dynamic>, e.reference)));

    // farms.add(FarmModel());
    farms.sort(((a, b) => a.name!.compareTo(b.name!)));
    return farms;
  }

  @override
  Future<List<ShareModel>> getSharedUsers(String? farmId) async {
    return _sharesCollection
        .where('farm_id', isEqualTo: farmId)
        .get()
        .then((value) => value.docs
            .map(
              (e) => ShareModel.getDocumentFromData(
                e.data() as Map<String, dynamic>,
                reference: e.reference,
              ),
            )
            .toList());
  }
}
