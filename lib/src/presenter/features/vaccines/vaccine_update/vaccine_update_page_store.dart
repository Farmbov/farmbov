// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/features/vaccines/vaccine_update/vaccine_update_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/domain/models/firestore/vaccine_model.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

class VaccineUpdatePageStore extends MobXStore<VaccineUpdatePageModel> {
  VaccineUpdatePageStore({VaccineModel? model})
      : super(VaccineUpdatePageModel(model: model));

  final formKey = GlobalKey<FormState>();

  init() {
    _loadModel();
  }

  dispose() {}

  void _loadModel() {
    if (state.model != null) {
      update(
        state.copyWith(
          name: state.model?.name,
          description: state.model?.description,
          lotNumber: state.model?.lotNumber,
          supplier: state.model?.supplier,
          producer: state.model?.producer,
          fabricationDate: state.model?.fabricationDate,
          dueDate: state.model?.dueDate,
          leafletUrl: state.model?.leafletUrl,
          daysToNextDose: state.model?.daysToNextDose,
        ),
      );
    }
  }

  void insert(BuildContext context) async {
    try {
      setLoading(true);

      if (formKey.currentState == null ||
          formKey.currentState?.validate() == false) {
        setLoading(false);
        return;
      }

      final vacinaCreateData = createVaccineData(
        name: state.name,
        description: state.description,
        lotNumber: state.lotNumber,
        supplier: state.supplier,
        producer: state.producer,
        fabricationDate: state.fabricationDate,
        dueDate: state.dueDate,
        leafletUrl: state.leafletUrl,
        daysToNextDose: state.daysToNextDose,
        create: true,
      );
      await VaccineModel.collection.doc().set(vacinaCreateData);

      showInsertSuccessModal(context);

      update(state, force: true);
      setLoading(false);
    } catch (e) {
      // TODO: create error modal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao criar vacina!'),
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  void edit(
    DocumentReference vacina,
    BuildContext context,
  ) async {
    try {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }

      final vacinaUpdateData = createVaccineData(
        name: state.name,
        description: state.description,
        lotNumber: state.lotNumber,
        supplier: state.supplier,
        producer: state.producer,
        fabricationDate: state.fabricationDate,
        dueDate: state.dueDate,
        leafletUrl: state.leafletUrl,
        daysToNextDose: state.daysToNextDose,
        create: false,
      );
      await vacina.update(vacinaUpdateData);

      showEditSuccessModal(context);
    } catch (e) {
      // TODO: create error modal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao editar vacina!'),
        ),
      );
    }
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Vacina criada com sucesso!',
        description:
            "A nova vacina foi adicionada com sucesso, e você pode encontrar"
            " todas as suas vacinas no menu Vacina.",
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
        title: 'Vacina editada com sucesso!',
        description:
            "Sua vacina foi editada com sucesso, e você pode encontrar "
            "todos as suas vacinas no menu Vacina.",
        popScopePageRoute: RouteName.vaccines,
        actionCallback: () {
          context.pop();
        },
        showCancel: false,
      ),
    );
  }
}
