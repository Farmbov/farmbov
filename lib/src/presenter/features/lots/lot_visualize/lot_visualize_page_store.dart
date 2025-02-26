// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/domain/models/firestore/lot_model.dart';

class LotVisualizePageStore extends MobXStore<LotModel?> {
  LotVisualizePageStore() : super(null);

  init({LotModel? model}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadModel(model: model);
    });
  }

  dispose() {}

  void _loadModel({LotModel? model}) {
    if (model != null) {
      update(model);
    }
  }
}
