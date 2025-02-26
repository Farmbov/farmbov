// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/constants/animal_down_reasons.dart';
import 'package:farmbov/src/domain/services/domain/animal_data_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/animal_down_reason_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_down_model.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

import '../../../../domain/repositories/animal_down_reasons_repository.dart';

const defaultIncorrectEntryNotes = 'Remoção manual';

class AnimalDownPageStore extends MobXStore<AnimalModel?> {
  AnimalDownPageStore({AnimalModel? model}) : super(model);

  final animalService = AnimalDataService();

  final formKey = GlobalKey<FormState>();

  TextEditingController tagNumberController = TextEditingController();
  TextEditingController momTagNumberController = TextEditingController();
  TextEditingController dadTagNumberController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController entryDateController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController weighingDateController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  final selectedAnimal = Observable<AnimalModel?>(null);
  final selectedAnimalDownReason = Observable<AnimalDownReasonModel?>(null);

  init({AnimalModel? model}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadModel(model: model);
    });
  }

  dispose() {
    tagNumberController.dispose();
    momTagNumberController.dispose();
    dadTagNumberController.dispose();
    weightController.dispose();
    entryDateController.dispose();
    birthDateController.dispose();
    weighingDateController.dispose();
    notesController.dispose();
  }

  void _loadModel({AnimalModel? model}) {
    if (model != null) {
      selectedAnimal.value = model;
      update(model);
    }
  }

  void selectAnimal(AnimalModel? animal) {
    selectedAnimal.value = animal;
    update(animal);
  }

  void selectAnimalDownReason(AnimalDownReasonModel? type) {
    selectedAnimalDownReason.value = type;
    update(null);
  }

  Future<List<AnimalDownReasonModel>> getAnimalDownReason(context) async {
    return await getAnimalDownReasons(context);
  }

  bool formIsValid() {
    return (formKey.currentState != null && formKey.currentState!.validate());
    // selectedAnimalDownReason.value != null &&
    // selectedAnimal.value != null;
  }

  Future<void> finishAnimalDown(
    BuildContext context, {
    AnimalModel? animal,
    bool closeModal = false,
  }) async {
    try {
      if (closeModal) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pop();
        });
      }

      Map<String, dynamic> baixaAnimalCreateData;

      if (animal != null) {
        selectAnimal(animal);

        baixaAnimalCreateData = createBaixaAnimalRecordData(
          tagNumber: animal.tagNumber,
          downReason:
              defaultAnimalDownReasons[AnimalDownReasonEnum.incorrectEntry]
                  ?.name,
          downDate: getCurrentTimestamp,
          notes: defaultIncorrectEntryNotes,
        );
      } else {
        animal = selectedAnimal.value;

        baixaAnimalCreateData = createBaixaAnimalRecordData(
          tagNumber: selectedAnimal.value!.tagNumber,
          downReason: selectedAnimalDownReason.value?.name,
          downDate: getCurrentTimestamp,
          notes: notesController.text,
        );
      }

      await AnimalDownModel.collection.doc().set(baixaAnimalCreateData);

      await animal?.ffRef?.update({
        'active': false,
        'updated_at': getCurrentTimestamp,
      });

      update(null);

      showInsertSuccessModal(context);
    } catch (e) {
      // TODO: create error modal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao dar baixar no animal!'),
        ),
      );
    }
  }

  Future<List<AnimalModel>> listAnimals({
    String? searchTerm,
    bool isActive = true,
  }) async {
    try {
      final animals = await animalService.listAnimals(isActive: isActive);
      return animals;
    } catch (error) {
      return [];
    }
  }

  void finish(BuildContext context) async {
    try {
      if (formIsValid() == false) return;

      await finishAnimalDown(context);
    } catch (e) {
      rethrow;
    }
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BaseAlertModal(
        title: 'Baixa de animal efetuada com sucesso!',
        description:
            "Seu animal foi baixado com sucesso, mas você ainda pode encontrar"
            " as informações sobre ele na área “meus animais”. ",
        popScopePageRoute: RouteName.home,
        showCancel: false,
        actionButtonTitle: "Ver meus animais",
        actionCallback: () => context.pop(),
        // cancelCallback: () => context.pop(),
      ),
    );
  }
}
