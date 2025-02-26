// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/features/lots/lot_update/lot_update_page_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/domain/models/firestore/lot_model.dart';
import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

class LotUpdatePageStore extends MobXStore<LotUpdatePageModel> {
  LotUpdatePageStore() : super(const LotUpdatePageModel());

  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController animalsAmountController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  init({LotModel? model}) {
    _loadModel(model: model);
  }

  dispose() {
    nameController.dispose();
    areaController.dispose();
    animalsAmountController.dispose();
    notesController.dispose();
  }

  void _loadModel({LotModel? model}) {
    if (model != null) {
      nameController.text = model.name ?? '';
      areaController.text = model.name ?? '';
      animalsAmountController.text = model.animalsCapacity?.toString() ?? "";
      notesController.text = model.notes ?? '';

      update(
        state.copyWith(
          name: model.name,
          selectedArea: model.area,
          animalsCapacity: model.animalsCapacity,
          notes: model.notes,
        ),
      );
    }
  }

  void insert(BuildContext context) async {
    try {
      setLoading(true);

      if (formKey.currentState == null ||
          formKey.currentState?.validate() == false) {
        return;
      }

      final loteCreateData = createLotModelData(
        name: nameController.text,
        area: state.selectedArea,
        animalsCapacity: int.tryParse(animalsAmountController.text),
        notes: notesController.text,
        create: true,
      );
      await LotModel.collection.doc().set(loteCreateData);

      showInsertSuccessModal(context);
    } catch (e) {
      setError(e as Exception);
      AlertManager.showToast('Erro ao salvar!');
    } finally {
      setLoading(false);
    }
  }

  void edit(
    DocumentReference model,
    BuildContext context,
  ) async {
    try {
      setLoading(true);

      if (formKey.currentState == null ||
          formKey.currentState?.validate() == false) {
        return;
      }

      final modelUpdate = createLotModelData(
        name: nameController.text,
        area: state.selectedArea,
        animalsCapacity: int.tryParse(animalsAmountController.text),
        notes: notesController.text,
        create: false,
      );
      await model.update(modelUpdate);

      showEditSuccessModal(context);
    } catch (e) {
      setError(e);
      AlertManager.showToast('Erro ao salvar!');
    } finally {
      setLoading(false);
    }
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Lote criado com sucesso!',
        description:
            "O novo lote foi adicionado com sucesso, e você pode encontrar"
            " todos os seus lotes no menu “Lote”.",
        popScopePageRoute: RouteName.lots,
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
        title: 'Lote editado com sucesso!',
        description: "Seu lote foi editado com sucesso, e você pode encontrar "
            "todos os seus lotes no menu “Lote”.",
        popScopePageRoute: RouteName.lots,
        showCancel: false,
        actionCallback: () {
          context.pop();
          context.pop();
        },
      ),
    );
  }
}
