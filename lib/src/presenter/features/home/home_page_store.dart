// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:farmbov/src/domain/constants/animal_sex.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/domain/models/firestore/farm_model.dart';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/services/domain/animal_data_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

class HomePageStore extends MobXStore {
  HomePageStore() : super(null);

  final formKey = GlobalKey<FormState>();

  TextEditingController? searchController;
  Timer? _debounceTimer;
  bool searchingTerm = false;

  List<String> selectedSexOptions =
      List<String>.from(animalSexList, growable: true);
  List<String> selectedLoteOptions = List<String>.empty(growable: true);

  final animalService = AnimalDataService();

  init(BuildContext context) {
    searchController = TextEditingController();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (AppManager.instance.user.currentFarm != null) return;
    //   showModalBottomSheet(
    //       context: context, builder: (_) => const StartFarmTutorialModal());
    // });
  }

  dispose() {
    searchController?.dispose();
    _debounceTimer?.cancel();
  }

  Future<void> searchGithub(String text) async {
    setLoading(true);

    try {
      EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
          () async {
        //final data = await repository.search(text);
        //update(SearchGithubSuccess(data ?? []));
      });
    }
    // on SearchGithubError catch (error) {
    //   setError(error);
    // }
    catch (error) {
      //setError(SearchGithubError('Erro Interno'));
    } finally {
      setLoading(false);
    }
  }

  Future<List<AnimalModel>> listAnimals({bool isActive = true}) async {
    try {
      final animals = await animalService.listAnimals(
        searchTerm: searchController?.text,
        isActive: isActive,
      );
      return animals;
    } catch (error) {
      return [];
    }
  }

  Stream<int> countAnimalsAsStream({bool isActive = true}) {
    try {
      final count =
          animalService.countAnimalsByStatusStream(isActive: isActive);
      return count;
    } catch (error) {
      return const Stream.empty();
    }
  }

  void updateFarmModal(
    BuildContext context, {
    FarmModel? model,
  }) {
    final id = model?.ffRef?.id;

    if (id == null) {
      context.go("${RouteName.home}/novo");
    } else {
      context.go("${RouteName.home}/$id", extra: {
        "model": model,
      });
    }
  }

  void showAnimalsFilterModal(BuildContext context) {}

  void clearSearch(BuildContext context) {
    searchController?.clear();
    FocusScope.of(context).unfocus();
  }
}
