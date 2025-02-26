// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/presenter/features/animals/animal_down/animal_down_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/services/domain/animal_data_service.dart';

import 'package:mobx/mobx.dart';

import '../home/widgets/animals_register_modal.dart';
part 'animals_page_store.g.dart';

final animalDataService = AnimalDataService();

class AnimalsPageStore = _AnimalsPageStoreBase with _$AnimalsPageStore;

abstract class _AnimalsPageStoreBase with Store {
  _AnimalsPageStoreBase({
    required this.showDownAnimal,
    required this.showAllAnimals,
  });

  @observable
  ObservableList<AnimalModel> animalsList = ObservableList();

  @observable
  bool showDownAnimal = false;

  @observable
  bool showAllAnimals = true;

  @observable
  bool hasMoreAnimalsToLoad = true;

  @observable
  DocumentSnapshot? startAfter;

  @observable
  String? selectedBreed;

  @observable
  String? selectedLot;

  @observable
  String? selectedSex;

  @observable
  String? selectedStatus;

  @observable
  DateTime? birthDateStart;

  @observable
  DateTime? birthDateEnd;

  @observable
  TextEditingController searchController = TextEditingController();

  @action
  void setShowDownAnimal(bool newValue) {
    showDownAnimal = newValue;
  }

  @action
  void setListAllAnimals(bool newValue) {
    showDownAnimal = newValue;
  }

  @action
  void setHasMoreAnimalsToLoad(bool newValue) {
    hasMoreAnimalsToLoad = newValue;
  }

  @action
  void setSelectedBreed(String? value) => selectedBreed = value;

  @action
  void setSelectedLot(String? value) => selectedLot = value;

  @action
  void setSelectedSex(String? value) => selectedSex = value;

  @action
  void setSelectedStatus(String? value) => selectedStatus = value;

  @action
  void setBirthDateStart(DateTime? value) => birthDateStart = value;

  @action
  void setBirthDateEnd(DateTime? value) => birthDateEnd = value;

  @action
  void clearFilters() {
    selectedBreed = null;
    selectedLot = null;
    selectedSex = null;
    selectedStatus = null;
    birthDateStart = null;
    birthDateEnd = null;
  }

  void deleteAnimalModal(
    BuildContext context,
    AnimalModel model,
  ) async {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir o animal?',
        popScopePageRoute: RouteName.animals,
        type: BaseModalType.danger,
        actionWidgets: [
          FFButton(
            text: 'Excluir animal',
            onPressed: () async {
              try {
                await AnimalDownPageStore().finishAnimalDown(
                  context,
                  animal: model,
                  closeModal: true,
                );

                if (model.photoUrl?.isNotEmpty ?? false) {
                  // TODO: arrumar (apagar do banco)
                  // await FirebaseStorage.instance
                  //     .refFromURL(animal.fotoUrl!)
                  //     .delete();
                }

                animalsList.remove(model);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro ao excluir animal'),
                  ),
                );
              }
            },
            backgroundColor: AppColors.feedbackDanger,
            borderColor: AppColors.feedbackDanger,
            textColor: Colors.white,
          ),
          const SizedBox(height: 16),
          FFButton(
            text: 'Cancelar',
            onPressed: () => context.pop(),
            backgroundColor: Colors.transparent,
            borderColor: AppColors.feedbackDanger,
            textColor: AppColors.feedbackDanger,
            splashColor: AppColors.feedbackDanger.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  @action
  Future<void> loadAnimals() async {
    List<AnimalModel> resultAnimals = [];

    if (showAllAnimals == true) {
      resultAnimals = await animalDataService.listAnimals(
          listAll: true, limit: 10, startAfter: startAfter);
    } else {
      if (showDownAnimal) {
        resultAnimals = await animalDataService.listAnimals(
            isActive: false, limit: 10, startAfter: startAfter);
      } else {
        resultAnimals = await animalDataService.listAnimals(
            isActive: true, limit: 10, startAfter: startAfter);
      }
    }

    if (resultAnimals.isNotEmpty) {
      if (resultAnimals.length < 10) {
        animalsList.addAll(resultAnimals);
        startAfter = null;
        await Future.delayed(const Duration(seconds: 1));
        setHasMoreAnimalsToLoad(false);
      } else {
        startAfter = await resultAnimals.last.ffRef?.get();
        animalsList.addAll(resultAnimals);
      }
    } else {
      setHasMoreAnimalsToLoad(false);
      startAfter = null;
    }
  }

  @action
  Future<void> advancedAnimalsSearch(BuildContext context) async {
    // await testIndexOnFirebase();

    // Exibir os filtros selecionados para depuração
    debugPrint('Buscando com os filtros:');
    debugPrint('Raça: $selectedBreed');
    debugPrint('Lote: $selectedLot');
    debugPrint('Sexo: $selectedSex');
    debugPrint('Situação: $selectedStatus');
    debugPrint('Data Nasc. Início: $birthDateStart');
    debugPrint('Data Nasc. Fim: $birthDateEnd');

    // Verifica se pelo menos um filtro foi preenchido
    if (selectedBreed != null && selectedBreed!.isNotEmpty ||
        selectedLot != null && selectedLot!.isNotEmpty ||
        selectedSex != null && selectedSex!.isNotEmpty ||
        selectedStatus != null && selectedStatus!.isNotEmpty ||
        birthDateStart != null ||
        birthDateEnd != null) {
      try {
        // Limpa a lista de animais antes de realizar uma nova busca
        animalsList.clear();
        startAfter = null; // Resetando paginação

        // Chama o método do repository passando os filtros selecionados
        List<AnimalModel> resultAnimals =
            await animalDataService.listAnimalsAdvanced(
          selectedBreed: selectedBreed,
          selectedLot: selectedLot,
          selectedSex: selectedSex,
          selectedStatus: selectedStatus,
          birthDateStart: birthDateStart,
          birthDateEnd: birthDateEnd,
          limit: 10, // Definir limite de animais por página
          startAfter: startAfter, // Paginação
        );

        // Verifica se obteve resultados
        if (resultAnimals.isNotEmpty) {
          animalsList.addAll(resultAnimals);

          // Atualiza o cursor para a próxima página (paginação)
          if (resultAnimals.length < 10) {
            setHasMoreAnimalsToLoad(false); // Não há mais animais para carregar
            startAfter = null;
          } else {
            startAfter = await resultAnimals.last.ffRef?.get();
            setHasMoreAnimalsToLoad(true);
          }
        } else {
          setHasMoreAnimalsToLoad(false);
        }
      } catch (e) {
        debugPrint('Erro ao realizar a busca avançada: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro ao buscar animais. Tente novamente.')),
        );
      }
    } else {
      // Nenhum filtro foi preenchido, exibe uma mensagem ao usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Preencha ao menos um filtro para realizar a busca.')),
      );
    }
  }

  void dispose() {
    searchController.dispose();
  }

  // TODOS OS CAMPOS DO DIALOG DEVEM ESTÁ PREENCHIDOS Apenas para buscar os indexes e criar no firebase
  Future<void> testIndexOnFirebase() async {
    debugPrint('===================UNICO');
    try {
      await animalDataService.listAnimalsAdvanced(selectedBreed: selectedBreed);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedBreed: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(selectedLot: selectedLot);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedLot: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(selectedSex: selectedSex);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedSex: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedStatus: selectedStatus);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedStatus: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          birthDateStart: birthDateStart);
    } catch (e) {
      debugPrint('Erro ao buscar por birthDateStart: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(birthDateEnd: birthDateEnd);
    } catch (e) {
      debugPrint('Erro ao buscar por birthDateEnd: $e');
    }

    debugPrint('===================DUPLO');
    try {
      await animalDataService.listAnimalsAdvanced(
          selectedBreed: selectedBreed, selectedLot: selectedLot);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedBreed e selectedLot: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedBreed: selectedBreed, selectedSex: selectedSex);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedBreed e selectedSex: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedBreed: selectedBreed, selectedStatus: selectedStatus);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedBreed e selectedStatus: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedBreed: selectedBreed, birthDateStart: birthDateStart);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedBreed e birthDateStart: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedBreed: selectedBreed, birthDateEnd: birthDateEnd);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedBreed e birthDateEnd: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedLot: selectedLot, selectedSex: selectedSex);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedLot e selectedSex: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedLot: selectedLot, selectedStatus: selectedStatus);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedLot e selectedStatus: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedLot: selectedLot, birthDateStart: birthDateStart);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedLot e birthDateStart: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedLot: selectedLot, birthDateEnd: birthDateEnd);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedLot e birthDateEnd: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedSex: selectedSex, selectedStatus: selectedStatus);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedSex e selectedStatus: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedSex: selectedSex, birthDateStart: birthDateStart);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedSex e birthDateStart: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedSex: selectedSex, birthDateEnd: birthDateEnd);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedSex e birthDateEnd: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedStatus: selectedStatus, birthDateStart: birthDateStart);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedStatus e birthDateStart: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          selectedStatus: selectedStatus, birthDateEnd: birthDateEnd);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedStatus e birthDateEnd: $e');
    }

    try {
      await animalDataService.listAnimalsAdvanced(
          birthDateStart: birthDateStart, birthDateEnd: birthDateEnd);
    } catch (e) {
      debugPrint('Erro ao buscar por birthDateStart e birthDateEnd: $e');
    }

    debugPrint('===================TRIO');
    try {
      await animalDataService.listAnimalsAdvanced(
          selectedBreed: selectedBreed,
          selectedLot: selectedLot,
          selectedSex: selectedSex);
    } catch (e) {
      debugPrint('Erro ao buscar por selectedBreed, selectedLot e selectedSex: $e');
    }

    // Continue com o padrão para todas as outras combinações...

    // TRIPLAS COMBINACOES CONTINUAM...
    // QUADRUPLAS E QUINTUPLAS...
    // SEIS FILTROS TAMBÉM PODEM SER FEITOS DA MESMA FORMA...

    // Exemplo para cinco e seis combinações:

    debugPrint('===================QUINTUPLO');
    try {
      await animalDataService.listAnimalsAdvanced(
          selectedBreed: selectedBreed,
          selectedLot: selectedLot,
          selectedSex: selectedSex,
          selectedStatus: selectedStatus,
          birthDateStart: birthDateStart);
    } catch (e) {
      debugPrint('Erro ao buscar por combinação de cinco filtros: $e');
    }

    debugPrint('===================SEXTUPLO');
    try {
      await animalDataService.listAnimalsAdvanced(
          selectedBreed: selectedBreed,
          selectedLot: selectedLot,
          selectedSex: selectedSex,
          selectedStatus: selectedStatus,
          birthDateStart: birthDateStart,
          birthDateEnd: birthDateEnd);
    } catch (e) {
      debugPrint('Erro ao buscar por combinação de seis filtros: $e');
    }
  }
}

showAnimalCreateModal(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    context: context,
    builder: (_) => const AnimalsRegisterModal(),
  );
}





/*


class AnimalsPageStore extends CommonBaseStore {
  AnimalsPageStore(
      {bool? showDownAnimals = false, bool? listAllAnimals = false})
      : super(null) {
    toggleShowDownAnimals.value = showDownAnimals ?? false;
    toggleListAllAnimals.value = listAllAnimals ?? true;

    // Definindo elementos do advanced filter
    setSelectedBreed =
        mobx.Action((String? value) => selectedBreed.value = value);
    setSelectedLot = mobx.Action((String? value) => selectedLot.value = value);
    setSelectedSex = mobx.Action((String? value) => selectedSex.value = value);
    setSelectedStatus =
        mobx.Action((String? value) => selectedStatus.value = value);
    setBirthDateStart =
        mobx.Action((DateTime? value) => birthDateStart.value = value);
    setBirthDateEnd =
        mobx.Action((DateTime? value) => birthDateEnd.value = value);

    advancedSearchAnimals = (mobx.Action(_advancedSearchAnimals));
    clearFilters = mobx.Action(_clearFilters);
  }

  final searchingTerm = mobx.Observable(false);
  final toggleShowDownAnimals = mobx.Observable(false);
  final toggleListAllAnimals = mobx.Observable(false);

  // final formKey = GlobalKey<FormState>();

  final mobx.ObservableList animalsList = mobx.ObservableList();

  final hasMore = mobx.Observable(true);

  DocumentSnapshot? startAfter;

  TextEditingController? searchController;

  Timer? _debounceTimer;

  @override
  init() {
    searchController ??= TextEditingController();
  }

  dispose() {
    _debounceTimer?.cancel();
    searchController?.dispose();
  }

  void setHasMore(bool newValue) {
    hasMore.value = newValue;
  }

  void togglehasMoreAnimals() {
    hasMore.toggle();
  }

  void toggleDownAnimals() {
    toggleShowDownAnimals.toggle();
  }

  void terminateAnimalModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => const AnimalsRegisterModal(),
    );
  }

  void deleteAnimalModal(
    BuildContext context,
    AnimalModel model,
  ) async {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir o animal?',
        popScopePageRoute: RouteName.animals,
        type: BaseModalType.danger,
        actionWidgets: [
          FFButton(
            text: 'Excluir animal',
            onPressed: () async {
              try {
                await AnimalDownPageStore().finishAnimalDown(
                  context,
                  animal: model,
                  closeModal: true,
                );

                if (model.photoUrl?.isNotEmpty ?? false) {
                  // TODO: arrumar (apagar do banco)
                  // await FirebaseStorage.instance
                  //     .refFromURL(animal.fotoUrl!)
                  //     .delete();
                }

                animalsList.remove(model);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro ao excluir animal'),
                  ),
                );
              }
            },
            backgroundColor: AppColors.feedbackDanger,
            borderColor: AppColors.feedbackDanger,
            textColor: Colors.white,
          ),
          const SizedBox(height: 16),
          FFButton(
            text: 'Cancelar',
            onPressed: () => context.pop(),
            backgroundColor: Colors.transparent,
            borderColor: AppColors.feedbackDanger,
            textColor: AppColors.feedbackDanger,
            splashColor: AppColors.feedbackDanger.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  void showAnimalsFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => AnimalsFilterModal(
        onSexSelected: (items) {
          // setState(() {
          //   _model.selectedSexOptions = items;
          // });
        },
        onLoteSelected: (items) {
          // setState(() {
          //   _model.selectedLoteOptions = items;
          // });
        },
        selectedSexItems: const [],
        selectedLoteItems: const [],
      ),
    );
  }

  void loadAnimals() async {
    List<AnimalModel> resultAnimals = [];

    if (toggleListAllAnimals.value) {
      resultAnimals = await animalDataService.listAnimals(
          listAll: true, limit: 10, startAfter: startAfter);
    } else {
      resultAnimals = await animalDataService.listAnimals(
          isActive: toggleShowDownAnimals.value,
          limit: 10,
          startAfter: startAfter);
    }

    if (resultAnimals.isNotEmpty) {
      startAfter = await resultAnimals.last.ffRef?.get();
      update(startAfter);
      if (resultAnimals.length < 10) {
        mobx.runInAction(() => hasMore.value = false);
        update(hasMore);
      }
      animalsList.addAll(resultAnimals);
    } else {
      mobx.runInAction(() => hasMore.value = false);

      update(hasMore);
    }
  }

// Observables
  final mobx.Observable<String?> selectedBreed = mobx.Observable(null);
  final mobx.Observable<String?> selectedLot = mobx.Observable(null);
  final mobx.Observable<String?> selectedSex = mobx.Observable(null);
  final mobx.Observable<String?> selectedStatus = mobx.Observable(null);
  final mobx.Observable<DateTime?> birthDateStart = mobx.Observable(null);
  final mobx.Observable<DateTime?> birthDateEnd = mobx.Observable(null);

  // Actions
  mobx.Action? setSelectedBreed;
  mobx.Action? setSelectedLot;
  mobx.Action? setSelectedSex;
  mobx.Action? setSelectedStatus;
  mobx.Action? setBirthDateStart;
  mobx.Action? setBirthDateEnd;
  mobx.Action? clearFilters;
  mobx.Action? advancedSearchAnimals;

  Future<void> _advancedSearchAnimals(BuildContext context) async {
    debugPrint('Buscando com os filtros:');
    debugPrint('Raça: ${selectedBreed.value}');
    debugPrint('Lote: ${selectedLot.value}');
    debugPrint('Sexo: ${selectedSex.value}');
    debugPrint('Situação: ${selectedStatus.value}');
    debugPrint('Data Nasc. Início: ${birthDateStart.value}');
    debugPrint('Data Nasc. Fim: ${birthDateEnd.value}');
    // TODO: CHAMADA AO FIREBASE E ADICIONAR DADOS AO ANIMAL LISTING
  }

  void _clearFilters() {
    selectedBreed.value = null;
    selectedLot.value = null;
    selectedSex.value = null;
    selectedStatus.value = null;
    birthDateStart.value = null;
    birthDateEnd.value = null;
  }
}

showAnimalCreateModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) => const AnimalsRegisterModal(),
  );
}
*/