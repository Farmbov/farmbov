import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/domain/models/vaccine_model.dart';
import 'package:mobx/mobx.dart';

import '../../../../common/providers/alert_manager.dart';
import '../../../../common/providers/app_manager.dart';
import '../../../../domain/models/global_farm_model.dart';
import '../../../../domain/models/vaccine_batch_model.dart';
part 'vaccine_batches_page_store.g.dart';

class VaccineBatchesPageStore = _VaccineBatchesPageStoreBase
    with _$VaccineBatchesPageStore;

abstract class _VaccineBatchesPageStoreBase with Store {
  @observable
  GlobalFarmModel? currentFarm = AppManager.instance.currentUser.currentFarm;

  @observable
  ObservableList<VaccineBatchModel> vaccineBatches =
      ObservableList<VaccineBatchModel>();

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchVaccineBatches({required VaccineModel vaccineModel}) async {
    try {
      isLoading = true;
      List<VaccineBatchModel> batches = await FirebaseFirestore.instance
          .collection('farms')
          .doc(currentFarm?.id)
          .collection('vaccines')
          .doc(vaccineModel.ref!.id.toString())
          .collection('batches')
          .get()
          .then((batches) {
        return batches.docs.map(
          (batche) {
            return VaccineBatchModel.fromJson(
              batche.data(),
              batche.reference,
            );
          },
        ).toList();
      });

      vaccineBatches.addAll(batches);
      isLoading = false;
    } catch (e) {
      AlertManager.showToast(
          'Erro ao carregar lotes da vacina ${vaccineModel.name}, tente mais tarde!');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> createVaccineBatch(
      {required VaccineBatchModel batch,
      required VaccineModel vaccineModel}) async {
    try {
      isLoading = true;
      final docRef = await FirebaseFirestore.instance
          .collection('farms')
          .doc(currentFarm?.id)
          .collection('vaccines')
          .doc(vaccineModel.ref!.id)
          .collection('batches')
          .add(batch.toJson());

      final newBatch = batch.copyWith(ref: docRef);
      vaccineBatches.add(newBatch);
    } catch (e) {
      AlertManager.showToast(
          'Erro ao criar o lote, tente novamente mais tarde.');
      print(e);
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> editVaccineBatch(VaccineBatchModel batch) async {
    try {
      isLoading = true;
      final docReference = batch.ref;
      if (docReference != null) {
        await docReference.update(batch.toJson());
        int index = vaccineBatches.indexWhere((b) => b.ref == docReference);
        if (index != -1) {
          vaccineBatches.replaceRange(index, index + 1, [batch]);
        }
      } else {
        print('Referência do documento é nula.');
      }
    } catch (e) {
      AlertManager.showToast(
          'Erro ao atualizar o lote, tente novamente mais tarde.');
      print(e);
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> deleteVaccineBatch(VaccineBatchModel batch) async {
    try {
      isLoading = true;
      final docReference = batch.ref;
      if (docReference != null) {
        await docReference.delete();
        vaccineBatches.removeWhere((b) => b.ref == docReference);
      } else {
        print('Referência do documento é nula.');
      }
    } catch (e) {
      AlertManager.showToast(
          'Erro ao deletar o lote, tente novamente mais tarde.');
      print(e);
    } finally {
      isLoading = false;
    }
  }
}
