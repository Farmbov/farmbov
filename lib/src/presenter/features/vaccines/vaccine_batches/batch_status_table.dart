import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../domain/models/vaccine_batch_model.dart';

class BatchStatusTable extends StatefulWidget {
  final ObservableList<VaccineBatchModel> vaccineBatches;

  const BatchStatusTable({super.key, required this.vaccineBatches});

  @override
  _BatchStatusTableState createState() => _BatchStatusTableState();
}

class _BatchStatusTableState extends State<BatchStatusTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  String _calculateDaysToExpire(DateTime expirationDate) {
    final currentDate = DateTime.now();
    final difference = expirationDate.difference(currentDate).inDays;
    return difference >= 0 ? '$difference dias' : 'Vencida';
  }

  Widget _buildStatusBadge(VaccineBatchModel batch) {
    final isExpired = DateTime.now().isAfter(batch.expirationDate);
    final isAvailable = batch.availableQuantity > 0;

    if (isExpired) {
      return _buildBadge('Vencida', Colors.red);
    } else if (isAvailable) {
      return _buildBadge('Disponível', Colors.green);
    } else {
      return _buildBadge('Esgotado', Colors.orange);
    }
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      widget.vaccineBatches.sort((a, b) {
        int compare;
        switch (columnIndex) {
          case 0: // Lote
            compare = a.batchNumber.compareTo(b.batchNumber);
            break;
          case 1: // Dias para Vencer
            compare = a.expirationDate.compareTo(b.expirationDate);
            break;
          case 2: // Doses em Estoque
            compare = a.availableQuantity.compareTo(b.availableQuantity);
            break;
          case 3: // Status
            compare = _getStatusOrder(a).compareTo(_getStatusOrder(b));
            break;
          default:
            return 0;
        }
        return ascending ? compare : -compare;
      });
    });
  }

  int _getStatusOrder(VaccineBatchModel batch) {
    final isExpired = DateTime.now().isAfter(batch.expirationDate);
    final isAvailable = batch.availableQuantity > 0;

    if (isExpired) return 3;
    if (isAvailable) return 1;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Status dos Lotes',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: AppColors.primaryGreen, fontSize: 16),
        ),
        DataTable(
          columnSpacing: ResponsiveBreakpoints.of(context).isMobile ? 10 : 30,
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: [
            DataColumn(
              label: const Text('Lote'),
              onSort: (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending),
            ),
            DataColumn(
              label: const Text('Vencimento'),
              onSort: (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending),
            ),
            DataColumn(
              label: const Text('Estoque'),
              onSort: (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending),
            ),
            DataColumn(
              label: const Text('Status'),
              onSort: (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending),
            ),
          ],
          rows: widget.vaccineBatches.map((batch) {
            return DataRow(
              cells: [
                DataCell(Text(batch.batchNumber)),
                DataCell(Text(_calculateDaysToExpire(batch.expirationDate))),
                DataCell(Text(batch.availableQuantity.toString())),
                DataCell(_buildStatusBadge(batch)),
              ],
            );
          }).toList(),
        ),
        const SizedBox(
          height: 100,
        )
      ],
    );
  }
}
