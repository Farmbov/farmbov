// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/constants/animal_handling_types.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/animal_handling_model.dart';
import 'package:farmbov/src/domain/models/firestore/vaccine_lot_model.dart';
import 'package:farmbov/src/domain/repositories/animal_repository.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_lot/vaccine_lot_update_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

import '../../../../common/providers/alert_manager.dart';
import '../../../../domain/models/vaccine_batch_model.dart';

class VaccineLotUpdatePageStore extends MobXStore<VaccineLotUpdatePageModel> {
  VaccineLotUpdatePageStore({
    VaccineLotModel? model,
    bool readOnly = false,
  }) : super(VaccineLotUpdatePageModel(
          model: model,
          readOnly: readOnly,
        ));

  final formKey = GlobalKey<FormState>();

  init() {
    _loadModel();
  }

  dispose() {}

  void _loadModel() {
    if (state.model != null) {
      update(
        state.copyWith(
          vaccineId: state.model?.vaccineId,
          lotId: state.model?.lotId,
          notes: state.model?.notes,
          applicationDate: state.model?.applicationDate,
        ),
      );
    }
  }

  Future<void> insert(BuildContext context) async {
    try {
      setLoading(true);

      if (formKey.currentState == null ||
          formKey.currentState!.validate() == false) {
        return;
      }

      if (_checkExpiredDueDate(context, state.selectedVaccine?.dueDate)) {
        return setLoading(false);
      }

      // TODO: Por algum motivo, aqui estava criando um lote de vacina toda vez que é realizado uma aplicação em lote. Verificar como isso afeta o restante do código como o fluxo de vacinas e lotes foi alterado.
      // final vacinaCreateData = createVaccineLotData(
      //   state.selectedVaccine!.ffRef!.id,
      //   state.selectedLot!.ffRef!.id,
      //   notes: state.notes,
      //   applicationDate: state.applicationDate,
      //   create: true,
      // );
      // await VaccineLotModel.collection.doc().set(vacinaCreateData);

      final savedHandling = await _saveVaccineHandling();

      if (!savedHandling) {
        return;
      }

      update(
        state.copyWith(
          vaccineId: state.selectedVaccine!.ffRef!.id,
          lotId: state.selectedLot!.ffRef!.id,
          notes: state.notes,
          applicationDate: state.applicationDate,
        ),
        force: true,
      );

      showInsertSuccessModal(context);
    } catch (e) {
      // TODO: create error modal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao aplicar vacina!'),
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> edit(DocumentReference vacina, BuildContext context) async {
    try {
      setLoading(true);

      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }

      if (_checkExpiredDueDate(context, state.selectedVaccine?.dueDate)) {
        return setLoading(false);
      }

      final vacinaUpdateData = createVaccineLotData(
        state.selectedVaccine!.ffRef!.id,
        state.selectedLot!.ffRef!.id,
        notes: state.notes,
        applicationDate: state.applicationDate,
        create: false,
      );
      await vacina.update(vacinaUpdateData);

      await _saveVaccineHandling();

      update(
        state.copyWith(
          vaccineId: state.selectedVaccine!.ffRef!.id,
          lotId: state.selectedLot!.ffRef!.id,
          notes: state.notes,
          applicationDate: state.applicationDate,
        ),
        force: true,
      );

      showEditSuccessModal(context);
    } catch (e) {
      // TODO: create error modal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao editar vacinaçao em lote!'),
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  Future<bool> _saveVaccineHandling() async {
    setLoading(true);

    // Coleta referências de animais do lote
    final animals =
        await AnimalRepositoryImpl().listAnimalsByLot(state.selectedLot!.name!);

    // Busca os lotes da vacina e filtra para obter os disponíveis
    final vaccineBatchesSnapshot = await state.selectedVaccine!.ffRef!
        .collection('batches')
        .where('available_quantity', isGreaterThan: 0)
        .where('expiration_date', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('expiration_date')
        .get();

    // Soma as doses disponíveis
    int totalAvailableDoses = 0;
    List<VaccineBatchModel> availableBatches = [];

    for (var batch in vaccineBatchesSnapshot.docs) {
      final batchData = batch.data();
      final availableQuantity = batchData['available_quantity'] as int;

      totalAvailableDoses += availableQuantity;
      availableBatches
          .add(VaccineBatchModel.fromJson(batchData, batch.reference));
    }

    // Verifica se há doses suficientes
    if (totalAvailableDoses < animals.length) {
      AlertManager.showToast(
          'Não há doses dessa vacina suficientes para a quantidade de animais do lote selecionado');
      setLoading(false);
      return false;
    }

    // Inicializa o Firestore Batch
    final batch = FirebaseFirestore.instance.batch();

    // Aplica o manejo sanitário para cada animal
    for (final animal in animals) {
      int dosesToReduce = 1; // Cada animal consome uma dose
      String? assignedBatchNumber; // Para armazenar o batch_number utilizado

      // Reduz as doses disponíveis
      for (var batchModel in availableBatches) {
        if (dosesToReduce <= 0) {
          break; // Se já atendemos a quantidade necessária
        }

        if (batchModel.availableQuantity > 0) {
          final availableQuantity = batchModel.availableQuantity;

          if (availableQuantity >= dosesToReduce) {
            // Reduz a quantidade do lote
            batchModel.availableQuantity -= dosesToReduce;
            assignedBatchNumber =
                batchModel.batchNumber; // Atribui o batch_number
            dosesToReduce = 0; // Todas as doses foram utilizadas
          } else {
            // Zera a quantidade do lote e reduz o restante
            dosesToReduce -= availableQuantity;
            batchModel.availableQuantity = 0; // Lote esgotado
            assignedBatchNumber =
                batchModel.batchNumber; // Atribui o batch_number
          }
        }
      }

      // Cria os dados do manejo, incluindo o batch_number
      final manejoCreateData = Map<String, dynamic>.from(createManejoRecordData(
        handlingType: AnimalHandlingTypes.sanitario.name,
        tagNumber: animal.tagNumber,
        handlingDate: state.applicationDate ?? getCurrentTimestamp,
        vaccine: state.selectedVaccine!.name,
      ));
      manejoCreateData['batch_number'] = assignedBatchNumber;

      // Adiciona a operação de escrita no batch
      final manejoRef = AnimalHandlingModel.collection.doc();
      batch.set(manejoRef, manejoCreateData);
    }

    // Atualiza os lotes no Firestore
    for (var batchModel in availableBatches) {
      if (batchModel.ref != null) {
        batch.update(batchModel.ref!,
            {'available_quantity': batchModel.availableQuantity});
      }
    }

    // Executa todas as operações no Firestore
    try {
      await batch.commit();
      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      AlertManager.showToast('Erro ao salvar manejos: $e');
      return false;
    }
  }

  bool _checkExpiredDueDate(
    BuildContext context,
    DateTime? vaccineDueData,
  ) {
    if (vaccineDueData != null && DateTime.now().isAfter(vaccineDueData)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vacina expirada'),
        ),
      );
      return true;
    }

    return false;
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Vacina aplicada com sucesso!',
        description:
            "A nova vacinaçao em lote foi adicionada com sucesso, e você pode encontrar"
            " todas as suas aplicações no menu Vacinas.",
        popScopePageRoute: RouteName.vaccines,
        actionCallback: () {
          context.pop();
        },
        showCancel: false,
      ),
    );
  }

  void showEditSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Vacinação em lote editada com sucesso!',
        description:
            "Sua vacinaçao em lote foi editada com sucesso, e você pode encontrar "
            "todos as suas aplicações vacinas no menu Vacina.",
        popScopePageRoute: RouteName.vaccines,
        actionCallback: () {
          context.pop();
        },
        showCancel: false,
      ),
    );
  }
}
