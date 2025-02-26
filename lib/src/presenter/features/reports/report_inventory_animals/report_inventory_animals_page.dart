import 'package:data_table_2/data_table_2.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/presenter/features/reports/reports_page_store.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/presenter/features/reports/widgets/datasources/generic_datasource.dart';
import 'package:farmbov/src/presenter/features/reports/widgets/report_section.dart';
import 'package:farmbov/src/presenter/features/reports/report_inventory_animals/report_inventory_animals_page_store.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ReportInventoryAnimalsPage extends StatefulWidget {
  final ReportInventoryAnimalsPageStore store;
  final ReportsPageStore baseStore;

  const ReportInventoryAnimalsPage({
    super.key,
    required this.store,
    required this.baseStore,
  });

  @override
  ReportInventoryAnimalsPageState createState() =>
      ReportInventoryAnimalsPageState();
}

class ReportInventoryAnimalsPageState
    extends State<ReportInventoryAnimalsPage> {
  @override
  void initState() {
    super.initState();
    widget.store.init();
  }

  @override
  void dispose() {
    widget.store.dispose();
    widget.baseStore.disposeStore();
    super.dispose();
  }

  EdgeInsetsGeometry _getPadding(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile
          ? const EdgeInsets.all(0)
          : const EdgeInsets.all(24);

  EdgeInsetsGeometry _getTitlePadding(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile
          ? const EdgeInsets.only(left: 24, top: 24)
          : const EdgeInsets.all(0);

  Widget _buildContent(BuildContext context) => ReportSection(
        title: 'Relatório de inventário de animais',
        store: widget.baseStore,
        dateRangeTitle: 'Data de nascimento',
        futureData: (startDate, endDate, handlingType) => queryAnimalRecordOnce(
          queryBuilder: (query) => query
              .where('birth_date',
                  isGreaterThanOrEqualTo: startDate ?? DateTime(1900))
              .where('birth_date',
                  isLessThanOrEqualTo: endDate ?? DateTime(2100))
              .orderBy('birth_date')
              .orderBy("tag_number")
              .startAt(
            [widget.store.baixaAnimalPage],
          ),
        ),
        futureCount: (startDate, endDate, handlingType) =>
            queryAnimalRecordCount(
          queryBuilder: (query) => query
              .where('birth_date',
                  isGreaterThanOrEqualTo: startDate ?? DateTime(1900))
              .where('birth_date',
                  isLessThanOrEqualTo: endDate ?? DateTime(2100))
              .orderBy('birth_date')
              .orderBy("tag_number")
              .startAt(
            [widget.store.baixaAnimalPage],
          ),
        ),
        headings: [
          GenericDataSourceItem('tag_number', textAlign: TextAlign.center),
          GenericDataSourceItem('breed', textAlign: TextAlign.center),
          GenericDataSourceItem('birth_date',
              type: TableItemType.date, textAlign: TextAlign.center),
          GenericDataSourceItem('mom_tag_number', textAlign: TextAlign.center),
          GenericDataSourceItem('dad_tag_number', textAlign: TextAlign.center),
        ],
        headingsTitle: [
          const DataColumn2(
            label: Center(child: Center(child: Text('Animal'))),
            //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
          ),
          const DataColumn2(
            label: Center(child: Text('Raça')),
          ),
          DataColumn2(
            label: Center(
                child: Text(ResponsiveBreakpoints.of(context).isMobile
                    ? 'Nasc.'
                    : 'Nascimento')),
          ),
          const DataColumn2(
            label: Center(
              child: Text(
                'Mãe',
              ),
            ),
          ),
          const DataColumn2(
            label: Center(child: Text('Pai')),
          ),
        ],
        noItemText: 'Nenhum animal encontrado.',
        screenshotController: widget.store.inventarioAnimalScreenshot,
        controller: widget.store.inventarioAnimalController,
        pageStart: widget.store.inventarioAnimalPage,
        take: widget.store.inventarioAnimalTake,
        onPageChanged: (page) {
          setState(() {
            widget.store.inventarioAnimalPage = page;
          });
        },
        onSearchChanged: widget.store.startSearchTimerInventario,
        rangeSelectorKey: GlobalKey(),
      );

  @override
  Widget build(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile
          ? _buildContent(context)
          : GenericPageContent(
              title: 'Relatórios',
              useGridRows: false,
              padding: _getPadding(context),
              titlePadding: _getTitlePadding(context),
              children: [
                _buildContent(context),
              ],
            );
}
