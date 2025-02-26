import 'package:farmbov/src/domain/repositories/vaccine_repository.dart';

import '../../models/vaccine_model.dart';

class VaccineService {
  static final VaccineService _instance = VaccineService._internal();

  factory VaccineService() => _instance;

  VaccineService._internal();

  final VaccineRepository _vaccineRepository = VaccineRepositoryImpl();

  Future<List<VaccineModel>> listVaccines() async {
    try {
      return _vaccineRepository.listVaccines();
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<VaccineModel>> listVaccinesAsStream() {
    try {
      return _vaccineRepository.listVaccinesAsStream();
    } catch (error) {
      rethrow;
    }
  }
}
