import '../../../../domain/models/global_farm_model.dart';
import '../../repositories/i_local_storage_repository.dart';

const currentFarmKey = 'current_farm';

class FarmLocalStorageService {
  final ILocalStorageRepository localStorage;

  FarmLocalStorageService(this.localStorage);

  Future<void> saveFarm(GlobalFarmModel farm) async {
    final farmJson = farm.toJson();
    await localStorage.write(currentFarmKey, farmJson);
  }

  Future<GlobalFarmModel?> readFarm() async {
    final farmJson = await localStorage.read(currentFarmKey);
    if (farmJson != null) {
      return GlobalFarmModel.fromJson(farmJson);
    }
    return null;
  }

  Future<void> deleteFarm() async {
    await localStorage.delete(currentFarmKey);
  }
}
