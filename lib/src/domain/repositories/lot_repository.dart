import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/domain/repositories/animal_repository.dart';

abstract class LotRepository {
  Future<bool> getLotCapacityIsFull(String lotName);
  Future<int?> getAnimalsCountByLotArea(String areaName);
}

class LotRepositoryImpl implements LotRepository {
  final _animalsRepository = AnimalRepositoryImpl();

  CollectionReference get _lotsCollection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('lots');
  }

  @override
  Future<bool> getLotCapacityIsFull(String lotName) async {
    final lot = await _lotsCollection
        .where('name', isEqualTo: lotName)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final lot = LotModel.getDocumentFromData(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        return lot;
      } else {
        return null;
      }
    });

    if (lot == null) return false;

    final currentAmount =
        await _animalsRepository.getAnimalsCountByLot(lotName) ?? 0;
    return (currentAmount + 1) > (lot.animalsCapacity ?? 0);
  }

  @override
  Future<int?> getAnimalsCountByLotArea(String areaName) async {
    final lots = await _lotsCollection
        .where('area', isEqualTo: areaName)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((e) => LotModel.getDocumentFromData(
                e.data() as Map<String, dynamic>,
                reference: e.reference))
            .toList();
      } else {
        return null;
      }
    });

    int currentAmount = 0;

    if (lots == null) return currentAmount;

    for (final lot in lots) {
      currentAmount +=
          await _animalsRepository.getAnimalsCountByLot(lot.name ?? '') ?? 0;
    }

    return currentAmount;
  }
}
