import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';

import '../models/vaccine_model.dart';

abstract class VaccineRepository {
  Future<List<VaccineModel>> listVaccines({
    String? searchTerm,
    bool isActive = true,
  });

  Stream<List<VaccineModel>> listVaccinesAsStream({
    String? searchTerm,
    bool isActive = true,
  });
}

class VaccineRepositoryImpl implements VaccineRepository {
  CollectionReference get _vaccinesCollection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('vaccines');
  }

  @override
  Future<List<VaccineModel>> listVaccines({
    String? searchTerm,
    bool isActive = true,
  }) async {
    var query = _vaccinesCollection.where('active', isEqualTo: isActive);

    // TODO: improve (use Angolia?)
    if (searchTerm != null && searchTerm.isNotEmpty) {
      query = query.where('name', arrayContains: searchTerm.toLowerCase());
    }

    query = query.orderBy('updated_at', descending: true);

    final querySnapshot = await query.get();
    final vaccineModels = <VaccineModel>[];

    for (var vaccine in querySnapshot.docs) {
      // Inicializa a quantidade total
      int quantity = 0;

      // Faz a requisição para buscar os lotes
      final batchesSnapshot = await vaccine.reference
          .collection('batches')
          .where('expiration_date', isGreaterThanOrEqualTo: DateTime.now())
          .get();

      // Soma as quantidades disponíveis de cada lote
      for (var batch in batchesSnapshot.docs) {
        quantity += (batch.data()['available_quantity'] as int?) ??
            0; // Adiciona a quantidade disponível
      }

      // Cria a instância de VaccineModel com a quantidade total calculada
      vaccineModels.add(
        VaccineModel.fromJson(
          vaccine.data() as Map<String, dynamic>,
          vaccine.reference,
          quantity: quantity,
        ),
      );
    }
    vaccineModels.sort((a, b) => a.name!.compareTo(b.name!));
    return vaccineModels;
  }

  @override
  Stream<List<VaccineModel>> listVaccinesAsStream({
    String? searchTerm,
    bool isActive = true,
  }) {
    var query = _vaccinesCollection.where('active', isEqualTo: isActive);
    query = query.orderBy('updated_at', descending: true);

    return query.snapshots().map((event) {
      return event.docs
          .map((e) => VaccineModel.fromJson(
              e.data() as Map<String, dynamic>, e.reference))
          .toList();
    });
  }
}
