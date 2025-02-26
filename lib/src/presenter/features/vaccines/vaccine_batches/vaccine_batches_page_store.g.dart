// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccine_batches_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VaccineBatchesPageStore on _VaccineBatchesPageStoreBase, Store {
  late final _$currentFarmAtom =
      Atom(name: '_VaccineBatchesPageStoreBase.currentFarm', context: context);

  @override
  GlobalFarmModel? get currentFarm {
    _$currentFarmAtom.reportRead();
    return super.currentFarm;
  }

  @override
  set currentFarm(GlobalFarmModel? value) {
    _$currentFarmAtom.reportWrite(value, super.currentFarm, () {
      super.currentFarm = value;
    });
  }

  late final _$vaccineBatchesAtom = Atom(
      name: '_VaccineBatchesPageStoreBase.vaccineBatches', context: context);

  @override
  ObservableList<VaccineBatchModel> get vaccineBatches {
    _$vaccineBatchesAtom.reportRead();
    return super.vaccineBatches;
  }

  @override
  set vaccineBatches(ObservableList<VaccineBatchModel> value) {
    _$vaccineBatchesAtom.reportWrite(value, super.vaccineBatches, () {
      super.vaccineBatches = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_VaccineBatchesPageStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$fetchVaccineBatchesAsyncAction = AsyncAction(
      '_VaccineBatchesPageStoreBase.fetchVaccineBatches',
      context: context);

  @override
  Future<void> fetchVaccineBatches({required VaccineModel vaccineModel}) {
    return _$fetchVaccineBatchesAsyncAction
        .run(() => super.fetchVaccineBatches(vaccineModel: vaccineModel));
  }

  late final _$createVaccineBatchAsyncAction = AsyncAction(
      '_VaccineBatchesPageStoreBase.createVaccineBatch',
      context: context);

  @override
  Future<void> createVaccineBatch(
      {required VaccineBatchModel batch, required VaccineModel vaccineModel}) {
    return _$createVaccineBatchAsyncAction.run(() =>
        super.createVaccineBatch(batch: batch, vaccineModel: vaccineModel));
  }

  late final _$editVaccineBatchAsyncAction = AsyncAction(
      '_VaccineBatchesPageStoreBase.editVaccineBatch',
      context: context);

  @override
  Future<void> editVaccineBatch(VaccineBatchModel batch) {
    return _$editVaccineBatchAsyncAction
        .run(() => super.editVaccineBatch(batch));
  }

  late final _$deleteVaccineBatchAsyncAction = AsyncAction(
      '_VaccineBatchesPageStoreBase.deleteVaccineBatch',
      context: context);

  @override
  Future<void> deleteVaccineBatch(VaccineBatchModel batch) {
    return _$deleteVaccineBatchAsyncAction
        .run(() => super.deleteVaccineBatch(batch));
  }

  @override
  String toString() {
    return '''
currentFarm: ${currentFarm},
vaccineBatches: ${vaccineBatches},
isLoading: ${isLoading}
    ''';
  }
}
