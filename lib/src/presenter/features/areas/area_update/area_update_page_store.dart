// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/domain/constants/area_usage_type.dart';
import 'package:farmbov/src/presenter/features/areas/area_update/area_update_page_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/domain/models/firestore/area_model.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';

class AreaUpdatePageStore extends MobXStore<AreaUpdatePageModel> {
  AreaUpdatePageStore() : super(const AreaUpdatePageModel());

  final formKey = GlobalKey<FormState>();

  void init({AreaModel? model}) => _loadModel(model: model);

  void _loadModel({AreaModel? model}) {
    if (model != null) {
      update(
        state.copyWith(
          selectedUsageType: defaultAreaUsageTypes.firstWhere(
            (element) => element.name == model.usageType,
          ),
          name: model.name,
          totalArea: model.totalArea,
          totalCapacity: model.totalCapacity,
          animalsLotsAmount: model.animalsLotsAmount,
          notes: model.notes,
        ),
      );
    }
  }

  void dispose() {}

  void insert(BuildContext context) async {
    try {
      setLoading(true);

      if (formKey.currentState == null ||
          formKey.currentState?.validate() == false) {
        return;
      }

      final model = createAreaModelData(
        name: state.name,
        totalArea: state.totalArea,
        totalCapacity: state.totalCapacity,
        notes: state.notes,
        // TODO: buscar em lots
        //animalsLotsAmount: int.tryParse(animalAmountController.text),
        usageType: state.selectedUsageType?.name,
        create: true,
      );

      await AreaModel.collection.doc().set(model);

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

      final updatedModel = createAreaModelData(
        name: state.name,
        totalArea: state.totalArea,
        totalCapacity: state.totalCapacity,
        notes: state.notes,
        // TODO: buscar em lots
        //animalsLotsAmount: int.tryParse(animalAmountController.text),
        usageType: state.selectedUsageType?.name,
        create: false,
      );
      await model.update(updatedModel);

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
        title: 'Área criada com sucesso!',
        description:
            'A nova área foi cadastrada com sucesso, e você pode encontrar'
            ' todas as suas áreas no menu "Minhas áreas."',
        popScopePageRoute: RouteName.areas,
        showCancel: false,
        actionCallback: () {
          context.pop();
        },
      ),
    );
  }

  void showEditSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Área editada com sucesso!',
        description: "Sua área foi editada com sucesso, e você pode encontrar "
            "todos as suas áreas no menu Área.",
        popScopePageRoute: RouteName.areas,
        showCancel: false,
        actionCallback: () {
          context.pop();
        },
      ),
    );
  }
}
