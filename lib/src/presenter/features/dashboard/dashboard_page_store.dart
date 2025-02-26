// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/domain/services/domain/animal_data_service.dart';
import 'package:farmbov/src/presenter/features/home/widgets/animals_register_modal.dart';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_triple/mobx_triple.dart';

class DashboardPageStore extends MobXStore {
  DashboardPageStore() : super(null);

  final animalService = AnimalDataService();

  final searchingTerm = Observable(false);

  final formKey = GlobalKey<FormState>();
  TextEditingController? searchController;

  Timer? _debounceTimer;

  init() {
    searchController ??= TextEditingController();
  }

  dispose() {
    _debounceTimer?.cancel();
    searchController?.dispose();
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

  void showAnimalsRegisterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => const AnimalsRegisterModal(),
    );
  }
}
