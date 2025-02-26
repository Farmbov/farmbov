import 'package:intl/intl.dart';
import 'package:farmbov/src/domain/models/firestore/base_model.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/presenter/features/home/widgets/generic_table_item.dart';

enum TableItemType { text, number, date }

class GenericDataSourceItem {
  final String key;
  final TableItemType type;
  final TextAlign textAlign;

  GenericDataSourceItem(
    this.key, {
    this.type = TableItemType.text,
    this.textAlign = TextAlign.left,
  });
}

class GenericDataSource {
  final dynamic data;
  final List<GenericDataSourceItem> propsMap;
  final int count;

  GenericDataSource(
    this.propsMap, {
    required this.data,
    this.count = 0,
  });

  String _getTableItemText(
    GenericDataSourceItem item,
    Map<String, dynamic>? values,
  ) {
    final value = values?[item.key];
    if (value == null) {
      return '-';
    }

    if (value is bool && item.type == TableItemType.text) {
      return value ? 'Sim' : 'Não';
    }

    if (item.type == TableItemType.number) {
      return value ?? '0';
    } else if (item.type == TableItemType.date) {
      return DateFormat('dd/MM/yyyy').format(value);
    }

    return value.isEmpty ? '-' : value;
  }

  List<DataCell> cells() {
    final baseModel = data as BaseModel;
    final map = baseModel.toMap();
    return propsMap
        .map(
          (prop) => DataCell(
            Center(
              child: GenericTableItem(
                text: _getTableItemText(prop, map),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
        .toList();
  }
}
