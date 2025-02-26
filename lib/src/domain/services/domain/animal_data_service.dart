import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/domain/repositories/animal_repository.dart';
import 'package:farmbov/src/domain/repositories/lot_repository.dart';

class AnimalDataService {
  static final AnimalDataService _instance = AnimalDataService._internal();

  factory AnimalDataService() => _instance;

  AnimalDataService._internal();

  final _animalRepository = AnimalRepositoryImpl();
  final _lotRepository = LotRepositoryImpl();

  Future<List<AnimalModel>> listAnimals(
      {String? searchTerm,
      // Apenas animais ativos (true), ou baixados (false)
      bool isActive = true,
      // Listar todos os animais (baixados ou não)
      bool listAll = false,
      bool onlyFemales = false,
      bool onlyMales = false,
      int? limit, // Limite de itens por página
      DocumentSnapshot? startAfter, // Cursor para a paginação
      String? lotName}) async {
    try {
      final search = (searchTerm?.length ?? 0) < 2 ? null : searchTerm;
      final animals = await _animalRepository.listAnimals(
          searchTerm: search,
          isActive: isActive,
          onlyFemales: onlyFemales,
          onlyMales: onlyMales,
          limit: limit,
          listAll: listAll,
          startAfter: startAfter,
          lotName: lotName);
      return animals;
    } catch (error) {
      rethrow;
    }
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
    try {
      final animals = await _animalRepository.listAnimalsAdvanced(
          selectedBreed: selectedBreed,
          selectedLot: selectedLot,
          selectedSex: selectedSex,
          selectedStatus: selectedStatus,
          birthDateStart: birthDateStart,
          birthDateEnd: birthDateEnd,
          isActive: isActive,
          limit: limit,
          listAll: listAll,
          startAfter: startAfter);
      return animals;
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<AnimalModel>> listAnimalsAsStream({
    bool isActive = true,
    // Listar todos os animais (baixados ou não)
    bool listAll = false,
  }) {
    try {
      return _animalRepository.listAnimalsAsStream(
        isActive: isActive,
        listAll: listAll,
      );
    } catch (error) {
      rethrow;
    }
  }

  Stream<int> countAnimalsByStatusStream({
    required bool isActive,
    String? lotNameFilter,
  }) {
    try {
      return _animalRepository.countAnimalsByStatusStream(
        isActive: isActive,
      );
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<AnimalModel>> listAnimalsByLotAsStream({
    bool isActive = true,
    String? lotNameFilter,
  }) {
    try {
      return _animalRepository.listAnimalsByLotAsStream(
        isActive: isActive,
        lotNameFilter: lotNameFilter,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<int?> getAnimalsCountByLot(String lotName) async {
    try {
      final count = await _animalRepository.getAnimalsCountByLot(lotName);
      return count;
    } catch (error) {
      rethrow;
    }
  }

  Future<int?> getAnimalsCountByLotArea(String areaName) async {
    try {
      final count = await _lotRepository.getAnimalsCountByLotArea(areaName);
      return count;
    } catch (error) {
      rethrow;
    }
  }
}
