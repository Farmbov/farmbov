import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';

abstract class AnimalRepository {
  Future<List<AnimalModel>> listAnimals({
    String? searchTerm,
    bool isActive = false,
    bool listAll = false,
  });

  Stream<List<AnimalModel>> listAnimalsAsStream({
    bool isActive = false,
    bool listAll = false,
  });

  Stream<List<AnimalModel>> listAnimalsByLotAsStream({
    bool isActive = false,
    String? lotNameFilter,
  });

  Stream<int> countAnimalsByStatusStream({
    required bool isActive,
    String? lotNameFilter,
  });

  Future<List<AnimalModel>> listAnimalsByLot(
    String lotName, {
    bool isActive = true,
  });

  Future<AnimalModel?> getAnimalById(String id);

  Future<int?> getAnimalsCountByLot(String lotName);
}

class AnimalRepositoryImpl implements AnimalRepository {
  CollectionReference get _animalsCollection {
    final farmId = AppManager.instance.currentUser.currentFarm?.id ?? 'unknown';
    return FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('animals');
  }

  @override
  Future<AnimalModel?> getAnimalById(String id) {
    return _animalsCollection.doc(id).get().then((value) {
      if (value.exists) {
        return AnimalModel.getDocumentFromData(
          value.data() as Map<String, dynamic>,
          reference: value.reference,
        );
      }
      return null;
    });
  }

  @override
  Future<List<AnimalModel>> listAnimals(
      {String? searchTerm,
      bool isActive = true,
      bool listAll = false,
      bool onlyFemales = false,
      bool onlyMales = false,
      int? limit, // Limite de itens por página
      DocumentSnapshot? startAfter, // Cursor para a paginação
      String? lotName}) async {
    Query<Object?> query;

    if (listAll) {
      query = _animalsCollection.orderBy('active', descending: true);
    } else {
      query = _animalsCollection.where('active', isEqualTo: isActive);
    }

    // TODO: improve (use Angolia?)
    if (searchTerm != null && searchTerm.isNotEmpty) {
      query = query.where(
        'tag_number',
        isGreaterThanOrEqualTo: searchTerm,
        isLessThan: searchTerm.substring(0, searchTerm.length - 1) +
            String.fromCharCode(
                searchTerm.codeUnitAt(searchTerm.length - 1) + 1),
      );
    }

    if (lotName != null) {
      query = query.where('lot', isEqualTo: lotName);
    }

    if (limit != null) {
      query = query.orderBy('tag_number', descending: false).limit(limit);
    } else {
      query = query.orderBy('tag_number', descending: false);
    }
    // Lida com a paginação, caso alista seja paginado vai continuar pelo último doc
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    QuerySnapshot animalsSnapshots = await query.get();

    List<AnimalModel> animals = animalsSnapshots.docs
        .map((doc) => AnimalModel.getDocumentFromData(
              doc.data() as Map<String, dynamic>,
              reference: doc.reference,
            ))
        .toList();

    // Adiciona o filtro para retornar apenas os animais do sexo "Fêmea" ou "Machos"
    if (onlyFemales) {
      return animals.where((animal) => animal.sex == 'Fêmea').toList();
    } else if (onlyMales) {
      return animals.where((animal) => animal.sex == 'Macho').toList();
    }

    return animals;
  }

  Future<List<AnimalModel>> listAnimalsAdvanced({
    String? selectedBreed,
    String? selectedLot,
    String? selectedSex,
    String? selectedStatus,
    DateTime? birthDateStart,
    DateTime? birthDateEnd,
    bool isActive = true,
    bool listAll = false,
    int? limit, // Limite de itens por página
    DocumentSnapshot? startAfter, // Cursor para a paginação
  }) async {
    Query<Object?> query = _animalsCollection;

    // Definindo a query base
    // if (listAll) {
    //   query = .orderBy('active', descending: true);
    // } else {
    //   query = _animalsCollection.where('active', isEqualTo: isActive);
    // }

    // Filtro por lote (selectedLot)
    if (selectedLot != null && selectedLot.isNotEmpty) {
      query = query.where('lot', isEqualTo: selectedLot);
    }

    // Filtro por sexo (selectedSex)
    if (selectedSex != null && selectedSex.isNotEmpty) {
      query = query.where('sex', isEqualTo: selectedSex);
    }

    // Filtro por situação (selectedStatus)
    if (selectedStatus != null && selectedStatus.isNotEmpty) {
      bool isActiveFilter = selectedStatus == 'Ativo';
      print('REPO');
      print(isActiveFilter);
      query = query.where('active', isEqualTo: isActiveFilter);
    }

    // Filtro por raça (selectedBreed)
    if (selectedBreed != null && selectedBreed.isNotEmpty) {
      query = query.where('breed', isEqualTo: selectedBreed);
    }

    // Filtro por intervalo de data de nascimento (birthDateStart e birthDateEnd)
    if (birthDateStart != null) {
      query = query.where('birth_date', isGreaterThanOrEqualTo: birthDateStart);
    }
    if (birthDateEnd != null) {
      query = query.where('birth_date', isLessThanOrEqualTo: birthDateEnd);
    }

    // Limite e ordenação por 'tag_number' para paginação
    query = query.orderBy('tag_number', descending: false);
    if (limit != null) {
      query = query.limit(limit);
    }

    // Paginação
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    // Executando a query
    QuerySnapshot animalsSnapshots = await query.get();
    List<AnimalModel> animals = animalsSnapshots.docs
        .map((doc) => AnimalModel.getDocumentFromData(
              doc.data() as Map<String, dynamic>,
              reference: doc.reference,
            ))
        .toList();

    return animals;
  }

  @override
  Stream<List<AnimalModel>> listAnimalsAsStream({
    bool isActive = false,
    bool listAll = false,
    String? lotNameFilter,
  }) {
    Query<Object?> query;

    if (listAll) {
      query = _animalsCollection;
    } else {
      query = _animalsCollection
          .where('active', isEqualTo: isActive)
          .orderBy('tag_number', descending: false);
    }

    return query.snapshots().map((event) => event.docs
        .map((e) => AnimalModel.getDocumentFromData(
              e.data() as Map<String, dynamic>,
              reference: e.reference,
            ))
        .toList());
  }

  @override
  Stream<int> countAnimalsByStatusStream({
    required bool isActive,
    String? lotNameFilter,
  }) {
    Query<Object?> query =
        _animalsCollection.where('active', isEqualTo: isActive);

    if (lotNameFilter != null) {
      query = query.where('lot_name', isEqualTo: lotNameFilter);
    }

    // Retorna um stream que atualiza a contagem sempre que houver mudanças
    return query.snapshots().map((snapshot) => snapshot.size);
  }

  @override
  Stream<List<AnimalModel>> listAnimalsByLotAsStream({
    bool isActive = false,
    String? lotNameFilter,
  }) {
    var query = _animalsCollection.where('active', isEqualTo: isActive);

    if (lotNameFilter != null) {
      query = query.where(
        'lot',
        isEqualTo: lotNameFilter,
      );
    }

    return query
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => AnimalModel.getDocumentFromData(
                  e.data() as Map<String, dynamic>,
                  reference: e.reference,
                ))
            .toList());
  }

  @override
  Future<List<AnimalModel>> listAnimalsByLot(
    String lotName, {
    bool isActive = true,
  }) {
    var query = _animalsCollection.where('active', isEqualTo: isActive);

    return query
        .where(
          'lot',
          isEqualTo: lotName,
        )
        .get()
        .then((value) {
      return value.docs
          .map((e) => AnimalModel.getDocumentFromData(
                e.data() as Map<String, dynamic>,
                reference: e.reference,
              ))
          .toList();
    });
  }

  @override
  Future<int?> getAnimalsCountByLot(String lotName) async {
    return _animalsCollection
        .where('lot', isEqualTo: lotName)
        .where('active', isEqualTo: true)
        .count()
        .get()
        .then((counter) => counter.count);
  }
}
