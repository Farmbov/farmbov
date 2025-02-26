// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animals_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AnimalsPageStore on _AnimalsPageStoreBase, Store {
  late final _$animalsListAtom =
      Atom(name: '_AnimalsPageStoreBase.animalsList', context: context);

  @override
  ObservableList<AnimalModel> get animalsList {
    _$animalsListAtom.reportRead();
    return super.animalsList;
  }

  @override
  set animalsList(ObservableList<AnimalModel> value) {
    _$animalsListAtom.reportWrite(value, super.animalsList, () {
      super.animalsList = value;
    });
  }

  late final _$showDownAnimalAtom =
      Atom(name: '_AnimalsPageStoreBase.showDownAnimal', context: context);

  @override
  bool get showDownAnimal {
    _$showDownAnimalAtom.reportRead();
    return super.showDownAnimal;
  }

  @override
  set showDownAnimal(bool value) {
    _$showDownAnimalAtom.reportWrite(value, super.showDownAnimal, () {
      super.showDownAnimal = value;
    });
  }

  late final _$showAllAnimalsAtom =
      Atom(name: '_AnimalsPageStoreBase.showAllAnimals', context: context);

  @override
  bool get showAllAnimals {
    _$showAllAnimalsAtom.reportRead();
    return super.showAllAnimals;
  }

  @override
  set showAllAnimals(bool value) {
    _$showAllAnimalsAtom.reportWrite(value, super.showAllAnimals, () {
      super.showAllAnimals = value;
    });
  }

  late final _$hasMoreAnimalsToLoadAtom = Atom(
      name: '_AnimalsPageStoreBase.hasMoreAnimalsToLoad', context: context);

  @override
  bool get hasMoreAnimalsToLoad {
    _$hasMoreAnimalsToLoadAtom.reportRead();
    return super.hasMoreAnimalsToLoad;
  }

  @override
  set hasMoreAnimalsToLoad(bool value) {
    _$hasMoreAnimalsToLoadAtom.reportWrite(value, super.hasMoreAnimalsToLoad,
        () {
      super.hasMoreAnimalsToLoad = value;
    });
  }

  late final _$startAfterAtom =
      Atom(name: '_AnimalsPageStoreBase.startAfter', context: context);

  @override
  DocumentSnapshot<Object?>? get startAfter {
    _$startAfterAtom.reportRead();
    return super.startAfter;
  }

  @override
  set startAfter(DocumentSnapshot<Object?>? value) {
    _$startAfterAtom.reportWrite(value, super.startAfter, () {
      super.startAfter = value;
    });
  }

  late final _$selectedBreedAtom =
      Atom(name: '_AnimalsPageStoreBase.selectedBreed', context: context);

  @override
  String? get selectedBreed {
    _$selectedBreedAtom.reportRead();
    return super.selectedBreed;
  }

  @override
  set selectedBreed(String? value) {
    _$selectedBreedAtom.reportWrite(value, super.selectedBreed, () {
      super.selectedBreed = value;
    });
  }

  late final _$selectedLotAtom =
      Atom(name: '_AnimalsPageStoreBase.selectedLot', context: context);

  @override
  String? get selectedLot {
    _$selectedLotAtom.reportRead();
    return super.selectedLot;
  }

  @override
  set selectedLot(String? value) {
    _$selectedLotAtom.reportWrite(value, super.selectedLot, () {
      super.selectedLot = value;
    });
  }

  late final _$selectedSexAtom =
      Atom(name: '_AnimalsPageStoreBase.selectedSex', context: context);

  @override
  String? get selectedSex {
    _$selectedSexAtom.reportRead();
    return super.selectedSex;
  }

  @override
  set selectedSex(String? value) {
    _$selectedSexAtom.reportWrite(value, super.selectedSex, () {
      super.selectedSex = value;
    });
  }

  late final _$selectedStatusAtom =
      Atom(name: '_AnimalsPageStoreBase.selectedStatus', context: context);

  @override
  String? get selectedStatus {
    _$selectedStatusAtom.reportRead();
    return super.selectedStatus;
  }

  @override
  set selectedStatus(String? value) {
    _$selectedStatusAtom.reportWrite(value, super.selectedStatus, () {
      super.selectedStatus = value;
    });
  }

  late final _$birthDateStartAtom =
      Atom(name: '_AnimalsPageStoreBase.birthDateStart', context: context);

  @override
  DateTime? get birthDateStart {
    _$birthDateStartAtom.reportRead();
    return super.birthDateStart;
  }

  @override
  set birthDateStart(DateTime? value) {
    _$birthDateStartAtom.reportWrite(value, super.birthDateStart, () {
      super.birthDateStart = value;
    });
  }

  late final _$birthDateEndAtom =
      Atom(name: '_AnimalsPageStoreBase.birthDateEnd', context: context);

  @override
  DateTime? get birthDateEnd {
    _$birthDateEndAtom.reportRead();
    return super.birthDateEnd;
  }

  @override
  set birthDateEnd(DateTime? value) {
    _$birthDateEndAtom.reportWrite(value, super.birthDateEnd, () {
      super.birthDateEnd = value;
    });
  }

  late final _$searchControllerAtom =
      Atom(name: '_AnimalsPageStoreBase.searchController', context: context);

  @override
  TextEditingController get searchController {
    _$searchControllerAtom.reportRead();
    return super.searchController;
  }

  @override
  set searchController(TextEditingController value) {
    _$searchControllerAtom.reportWrite(value, super.searchController, () {
      super.searchController = value;
    });
  }

  late final _$loadAnimalsAsyncAction =
      AsyncAction('_AnimalsPageStoreBase.loadAnimals', context: context);

  @override
  Future<void> loadAnimals() {
    return _$loadAnimalsAsyncAction.run(() => super.loadAnimals());
  }

  late final _$advancedAnimalsSearchAsyncAction = AsyncAction(
      '_AnimalsPageStoreBase.advancedAnimalsSearch',
      context: context);

  @override
  Future<void> advancedAnimalsSearch(BuildContext context) {
    return _$advancedAnimalsSearchAsyncAction
        .run(() => super.advancedAnimalsSearch(context));
  }

  late final _$_AnimalsPageStoreBaseActionController =
      ActionController(name: '_AnimalsPageStoreBase', context: context);

  @override
  void setShowDownAnimal(bool newValue) {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.setShowDownAnimal');
    try {
      return super.setShowDownAnimal(newValue);
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setListAllAnimals(bool newValue) {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.setListAllAnimals');
    try {
      return super.setListAllAnimals(newValue);
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHasMoreAnimalsToLoad(bool newValue) {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.setHasMoreAnimalsToLoad');
    try {
      return super.setHasMoreAnimalsToLoad(newValue);
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedBreed(String? value) {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.setSelectedBreed');
    try {
      return super.setSelectedBreed(value);
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedLot(String? value) {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.setSelectedLot');
    try {
      return super.setSelectedLot(value);
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedSex(String? value) {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.setSelectedSex');
    try {
      return super.setSelectedSex(value);
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedStatus(String? value) {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.setSelectedStatus');
    try {
      return super.setSelectedStatus(value);
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBirthDateStart(DateTime? value) {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.setBirthDateStart');
    try {
      return super.setBirthDateStart(value);
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBirthDateEnd(DateTime? value) {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.setBirthDateEnd');
    try {
      return super.setBirthDateEnd(value);
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$_AnimalsPageStoreBaseActionController.startAction(
        name: '_AnimalsPageStoreBase.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$_AnimalsPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
animalsList: ${animalsList},
showDownAnimal: ${showDownAnimal},
showAllAnimals: ${showAllAnimals},
hasMoreAnimalsToLoad: ${hasMoreAnimalsToLoad},
startAfter: ${startAfter},
selectedBreed: ${selectedBreed},
selectedLot: ${selectedLot},
selectedSex: ${selectedSex},
selectedStatus: ${selectedStatus},
birthDateStart: ${birthDateStart},
birthDateEnd: ${birthDateEnd},
searchController: ${searchController}
    ''';
  }
}
