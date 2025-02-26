// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal_handling_update_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AnimalHandlingUpdatePageStore
    on _AnimalHandlingUpdatePageStoreBase, Store {
  Computed<bool>? _$formIsValidComputed;

  @override
  bool get formIsValid =>
      (_$formIsValidComputed ??= Computed<bool>(() => super.formIsValid,
              name: '_AnimalHandlingUpdatePageStoreBase.formIsValid'))
          .value;

  late final _$isLoadingAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.isLoading', context: context);

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

  late final _$modelAtom =
      Atom(name: '_AnimalHandlingUpdatePageStoreBase.model', context: context);

  @override
  AnimalHandlingModel? get model {
    _$modelAtom.reportRead();
    return super.model;
  }

  @override
  set model(AnimalHandlingModel? value) {
    _$modelAtom.reportWrite(value, super.model, () {
      super.model = value;
    });
  }

  late final _$animalAtom =
      Atom(name: '_AnimalHandlingUpdatePageStoreBase.animal', context: context);

  @override
  AnimalModel? get animal {
    _$animalAtom.reportRead();
    return super.animal;
  }

  @override
  set animal(AnimalModel? value) {
    _$animalAtom.reportWrite(value, super.animal, () {
      super.animal = value;
    });
  }

  late final _$selectedMaleAnimalAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.selectedMaleAnimal',
      context: context);

  @override
  AnimalModel? get selectedMaleAnimal {
    _$selectedMaleAnimalAtom.reportRead();
    return super.selectedMaleAnimal;
  }

  @override
  set selectedMaleAnimal(AnimalModel? value) {
    _$selectedMaleAnimalAtom.reportWrite(value, super.selectedMaleAnimal, () {
      super.selectedMaleAnimal = value;
    });
  }

  late final _$handlingTypeAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.handlingType',
      context: context);

  @override
  AnimalHandlingTypes? get handlingType {
    _$handlingTypeAtom.reportRead();
    return super.handlingType;
  }

  @override
  set handlingType(AnimalHandlingTypes? value) {
    _$handlingTypeAtom.reportWrite(value, super.handlingType, () {
      super.handlingType = value;
    });
  }

  late final _$weightHandlingDateAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.weightHandlingDate',
      context: context);

  @override
  DateTime? get weightHandlingDate {
    _$weightHandlingDateAtom.reportRead();
    return super.weightHandlingDate;
  }

  @override
  set weightHandlingDate(DateTime? value) {
    _$weightHandlingDateAtom.reportWrite(value, super.weightHandlingDate, () {
      super.weightHandlingDate = value;
    });
  }

  late final _$healthHandlingDateAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.healthHandlingDate',
      context: context);

  @override
  DateTime? get healthHandlingDate {
    _$healthHandlingDateAtom.reportRead();
    return super.healthHandlingDate;
  }

  @override
  set healthHandlingDate(DateTime? value) {
    _$healthHandlingDateAtom.reportWrite(value, super.healthHandlingDate, () {
      super.healthHandlingDate = value;
    });
  }

  late final _$reproductionHandlingDateAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.reproductionHandlingDate',
      context: context);

  @override
  DateTime? get reproductionHandlingDate {
    _$reproductionHandlingDateAtom.reportRead();
    return super.reproductionHandlingDate;
  }

  @override
  set reproductionHandlingDate(DateTime? value) {
    _$reproductionHandlingDateAtom
        .reportWrite(value, super.reproductionHandlingDate, () {
      super.reproductionHandlingDate = value;
    });
  }

  late final _$pregnantLikelyDateAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.pregnantLikelyDate',
      context: context);

  @override
  DateTime? get pregnantLikelyDate {
    _$pregnantLikelyDateAtom.reportRead();
    return super.pregnantLikelyDate;
  }

  @override
  set pregnantLikelyDate(DateTime? value) {
    _$pregnantLikelyDateAtom.reportWrite(value, super.pregnantLikelyDate, () {
      super.pregnantLikelyDate = value;
    });
  }

  late final _$vaccineAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.vaccine', context: context);

  @override
  String? get vaccine {
    _$vaccineAtom.reportRead();
    return super.vaccine;
  }

  @override
  set vaccine(String? value) {
    _$vaccineAtom.reportWrite(value, super.vaccine, () {
      super.vaccine = value;
    });
  }

  late final _$isPregnantAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.isPregnant', context: context);

  @override
  bool get isPregnant {
    _$isPregnantAtom.reportRead();
    return super.isPregnant;
  }

  @override
  set isPregnant(bool value) {
    _$isPregnantAtom.reportWrite(value, super.isPregnant, () {
      super.isPregnant = value;
    });
  }

  late final _$isHandlingTypeSelectedAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.isHandlingTypeSelected',
      context: context);

  @override
  bool get isHandlingTypeSelected {
    _$isHandlingTypeSelectedAtom.reportRead();
    return super.isHandlingTypeSelected;
  }

  @override
  set isHandlingTypeSelected(bool value) {
    _$isHandlingTypeSelectedAtom
        .reportWrite(value, super.isHandlingTypeSelected, () {
      super.isHandlingTypeSelected = value;
    });
  }

  late final _$activeAnimalsAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.activeAnimals',
      context: context);

  @override
  ObservableList<AnimalModel> get activeAnimals {
    _$activeAnimalsAtom.reportRead();
    return super.activeAnimals;
  }

  @override
  set activeAnimals(ObservableList<AnimalModel> value) {
    _$activeAnimalsAtom.reportWrite(value, super.activeAnimals, () {
      super.activeAnimals = value;
    });
  }

  late final _$weightControllerAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.weightController',
      context: context);

  @override
  TextEditingController get weightController {
    _$weightControllerAtom.reportRead();
    return super.weightController;
  }

  @override
  set weightController(TextEditingController value) {
    _$weightControllerAtom.reportWrite(value, super.weightController, () {
      super.weightController = value;
    });
  }

  late final _$isLastStepAtom = Atom(
      name: '_AnimalHandlingUpdatePageStoreBase.isLastStep', context: context);

  @override
  bool get isLastStep {
    _$isLastStepAtom.reportRead();
    return super.isLastStep;
  }

  @override
  set isLastStep(bool value) {
    _$isLastStepAtom.reportWrite(value, super.isLastStep, () {
      super.isLastStep = value;
    });
  }

  late final _$_initAsyncAction =
      AsyncAction('_AnimalHandlingUpdatePageStoreBase._init', context: context);

  @override
  Future<void> _init() {
    return _$_initAsyncAction.run(() => super._init());
  }

  late final _$loadActiveAnimalsAsyncAction = AsyncAction(
      '_AnimalHandlingUpdatePageStoreBase.loadActiveAnimals',
      context: context);

  @override
  Future<void> loadActiveAnimals() {
    return _$loadActiveAnimalsAsyncAction.run(() => super.loadActiveAnimals());
  }

  late final _$finishAsyncAction = AsyncAction(
      '_AnimalHandlingUpdatePageStoreBase.finish',
      context: context);

  @override
  Future<void> finish(BuildContext context) {
    return _$finishAsyncAction.run(() => super.finish(context));
  }

  late final _$finishPesagemAsyncAction = AsyncAction(
      '_AnimalHandlingUpdatePageStoreBase.finishPesagem',
      context: context);

  @override
  Future<void> finishPesagem(BuildContext context) {
    return _$finishPesagemAsyncAction.run(() => super.finishPesagem(context));
  }

  late final _$finishReprodutivoAsyncAction = AsyncAction(
      '_AnimalHandlingUpdatePageStoreBase.finishReprodutivo',
      context: context);

  @override
  Future<void> finishReprodutivo(BuildContext context) {
    return _$finishReprodutivoAsyncAction
        .run(() => super.finishReprodutivo(context));
  }

  late final _$finishSanitarioAsyncAction = AsyncAction(
      '_AnimalHandlingUpdatePageStoreBase.finishSanitario',
      context: context);

  @override
  Future<void> finishSanitario(BuildContext context,
      {VaccineModel? selectedVaccine,
      DateTime? handlingDate,
      AnimalModel? selectedAnimal}) {
    return _$finishSanitarioAsyncAction.run(() => super.finishSanitario(context,
        selectedVaccine: selectedVaccine,
        handlingDate: handlingDate,
        selectedAnimal: selectedAnimal));
  }

  late final _$_AnimalHandlingUpdatePageStoreBaseActionController =
      ActionController(
          name: '_AnimalHandlingUpdatePageStoreBase', context: context);

  @override
  void updateIsLastStep(bool newState) {
    final _$actionInfo =
        _$_AnimalHandlingUpdatePageStoreBaseActionController.startAction(
            name: '_AnimalHandlingUpdatePageStoreBase.updateIsLastStep');
    try {
      return super.updateIsLastStep(newState);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updateHandlingType(AnimalHandlingTypes? type) {
    final _$actionInfo =
        _$_AnimalHandlingUpdatePageStoreBaseActionController.startAction(
            name: '_AnimalHandlingUpdatePageStoreBase.updateHandlingType');
    try {
      return super.updateHandlingType(type);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updateModel(AnimalHandlingModel? newModel) {
    final _$actionInfo = _$_AnimalHandlingUpdatePageStoreBaseActionController
        .startAction(name: '_AnimalHandlingUpdatePageStoreBase.updateModel');
    try {
      return super.updateModel(newModel);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updateSelectedAnimal(AnimalModel? newAnimal) {
    final _$actionInfo =
        _$_AnimalHandlingUpdatePageStoreBaseActionController.startAction(
            name: '_AnimalHandlingUpdatePageStoreBase.updateSelectedAnimal');
    try {
      return super.updateSelectedAnimal(newAnimal);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updateSelectedMaleAnimal(AnimalModel? maleAnimal) {
    final _$actionInfo =
        _$_AnimalHandlingUpdatePageStoreBaseActionController.startAction(
            name:
                '_AnimalHandlingUpdatePageStoreBase.updateSelectedMaleAnimal');
    try {
      return super.updateSelectedMaleAnimal(maleAnimal);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updateWeightHandlingDate(DateTime? date) {
    final _$actionInfo =
        _$_AnimalHandlingUpdatePageStoreBaseActionController.startAction(
            name:
                '_AnimalHandlingUpdatePageStoreBase.updateWeightHandlingDate');
    try {
      return super.updateWeightHandlingDate(date);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updateHealthHandlingDate(DateTime? date) {
    final _$actionInfo =
        _$_AnimalHandlingUpdatePageStoreBaseActionController.startAction(
            name:
                '_AnimalHandlingUpdatePageStoreBase.updateHealthHandlingDate');
    try {
      return super.updateHealthHandlingDate(date);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updateReproductionHandlingDate(DateTime? date) {
    final _$actionInfo =
        _$_AnimalHandlingUpdatePageStoreBaseActionController.startAction(
            name:
                '_AnimalHandlingUpdatePageStoreBase.updateReproductionHandlingDate');
    try {
      return super.updateReproductionHandlingDate(date);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updatePregnancyStatus(bool pregnant) {
    final _$actionInfo =
        _$_AnimalHandlingUpdatePageStoreBaseActionController.startAction(
            name: '_AnimalHandlingUpdatePageStoreBase.updatePregnancyStatus');
    try {
      return super.updatePregnancyStatus(pregnant);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updatePregnantLikelyDate(DateTime? date) {
    final _$actionInfo =
        _$_AnimalHandlingUpdatePageStoreBaseActionController.startAction(
            name:
                '_AnimalHandlingUpdatePageStoreBase.updatePregnantLikelyDate');
    try {
      return super.updatePregnantLikelyDate(date);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void updateVaccine(String? newVaccine) {
    final _$actionInfo = _$_AnimalHandlingUpdatePageStoreBaseActionController
        .startAction(name: '_AnimalHandlingUpdatePageStoreBase.updateVaccine');
    try {
      return super.updateVaccine(newVaccine);
    } finally {
      _$_AnimalHandlingUpdatePageStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
model: ${model},
animal: ${animal},
selectedMaleAnimal: ${selectedMaleAnimal},
handlingType: ${handlingType},
weightHandlingDate: ${weightHandlingDate},
healthHandlingDate: ${healthHandlingDate},
reproductionHandlingDate: ${reproductionHandlingDate},
pregnantLikelyDate: ${pregnantLikelyDate},
vaccine: ${vaccine},
isPregnant: ${isPregnant},
isHandlingTypeSelected: ${isHandlingTypeSelected},
activeAnimals: ${activeAnimals},
weightController: ${weightController},
isLastStep: ${isLastStep},
formIsValid: ${formIsValid}
    ''';
  }
}
