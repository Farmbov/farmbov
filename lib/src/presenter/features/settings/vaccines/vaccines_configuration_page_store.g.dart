// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccines_configuration_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VaccinesConfigurationPageStore
    on _VaccinesConfigurationPageStoreBase, Store {
  late final _$isLoadingAtom = Atom(
      name: '_VaccinesConfigurationPageStoreBase.isLoading', context: context);

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

  late final _$fetchFarmVaccinesAsyncAction = AsyncAction(
      '_VaccinesConfigurationPageStoreBase.fetchFarmVaccines',
      context: context);

  @override
  Future<void> fetchFarmVaccines() {
    return _$fetchFarmVaccinesAsyncAction.run(() => super.fetchFarmVaccines());
  }

  late final _$fetchDrugAdministrationTypesAsyncAction = AsyncAction(
      '_VaccinesConfigurationPageStoreBase.fetchDrugAdministrationTypes',
      context: context);

  @override
  Future<void> fetchDrugAdministrationTypes() {
    return _$fetchDrugAdministrationTypesAsyncAction
        .run(() => super.fetchDrugAdministrationTypes());
  }

  late final _$addVaccineAsyncAction = AsyncAction(
      '_VaccinesConfigurationPageStoreBase.addVaccine',
      context: context);

  @override
  Future<void> addVaccine(VaccineModel vaccineModel) {
    return _$addVaccineAsyncAction.run(() => super.addVaccine(vaccineModel));
  }

  late final _$updateVaccineAsyncAction = AsyncAction(
      '_VaccinesConfigurationPageStoreBase.updateVaccine',
      context: context);

  @override
  Future<void> updateVaccine(VaccineModel vaccineModel) {
    return _$updateVaccineAsyncAction
        .run(() => super.updateVaccine(vaccineModel));
  }

  late final _$deleteVaccineAsyncAction = AsyncAction(
      '_VaccinesConfigurationPageStoreBase.deleteVaccine',
      context: context);

  @override
  Future<void> deleteVaccine(BuildContext context,
      {required VaccineModel vaccineModel}) {
    return _$deleteVaccineAsyncAction
        .run(() => super.deleteVaccine(context, vaccineModel: vaccineModel));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading}
    ''';
  }
}
