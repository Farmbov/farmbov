import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:screenshot/screenshot.dart';

import 'package:farmbov/src/domain/constants/pagination.dart';

class ReportInventoryAnimalsPageStore extends MobXStore {
  ReportInventoryAnimalsPageStore() : super(null);

  final baixaAnimalScreenshot = ScreenshotController();
  final manejoScreenshot = ScreenshotController();
  final inventarioAnimalScreenshot = ScreenshotController();

  final baixaAnimalController = TextEditingController();
  final manejoController = TextEditingController();
  final inventarioAnimalController = TextEditingController();

  bool searchingTermBaixa = false;
  bool searchingTermManejo = false;
  bool searchingTermInventario = false;

  var baixaAnimalPage = 0;
  final baixaAnimalTake = itemsTake;
  Timer? _debounceTimerBaixa;

  var manejoPage = 0;
  final manejoTake = itemsTake;

  Timer? _debounceTimerManejo;

  var inventarioAnimalPage = 0;
  final inventarioAnimalTake = itemsTake;
  Timer? _debounceTimerInventario;

  void init() {}

  void dispose() {
    _debounceTimerBaixa?.cancel();
    _debounceTimerManejo?.cancel();
    _debounceTimerInventario?.cancel();
    baixaAnimalController.dispose();
    manejoController.dispose();
    inventarioAnimalController.dispose();
  }

  void startSearchTimerBaixa(String keyword) {
    _debounceTimerBaixa?.cancel();
    if (keyword.length >= 3) {
      searchingTermBaixa = true;
      _debounceTimerBaixa = Timer(const Duration(milliseconds: 250), () {
        searchingTermBaixa = false;
      });
    }
  }

  void startSearchTimerInventario(String keyword) {
    _debounceTimerInventario?.cancel();
    if (keyword.length >= 3) {
      searchingTermInventario = true;
      _debounceTimerInventario = Timer(const Duration(milliseconds: 250), () {
        searchingTermInventario = false;
      });
    }
  }
}
