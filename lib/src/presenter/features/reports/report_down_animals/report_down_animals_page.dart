import 'package:data_table_2/data_table_2.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/presenter/features/reports/report_down_animals/report_down_animals_page_store.dart';
import 'package:farmbov/src/presenter/features/reports/reports_page_store.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/presenter/features/reports/widgets/datasources/generic_datasource.dart';
import 'package:farmbov/src/presenter/features/reports/widgets/report_section.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ReportDownAnimalsPage extends StatefulWidget {
  final ReportDownAnimalsPageStore store;
  final ReportsPageStore baseStore;

  const ReportDownAnimalsPage({
    super.key,
    required this.store,
    required this.baseStore,
  });

  @override
  ReportDownAnimalsPageState createState() => ReportDownAnimalsPageState();
}

class ReportDownAnimalsPageState extends State<ReportDownAnimalsPage> {
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
        title: 'Relatório de baixas no rebanho',
        store: widget.baseStore,
        dateRangeTitle: 'Data da baixa',
        futureData: (startDate, endDate, handlingType) =>
            queryBaixaAnimalRecordOnce(
          queryBuilder: (query) => query
              .where('down_date',
                  isGreaterThanOrEqualTo: startDate ?? DateTime(1900))
              .where('down_date',
                  isLessThanOrEqualTo: endDate ?? DateTime(2100))
              .orderBy('down_date')
              .orderBy("tag_number")
              .startAt(
            [widget.store.baixaAnimalPage],
          ),
        ),
        futureCount: (startDate, endDate, handlingType) =>
            queryBaixaAnimalRecordCount(
          queryBuilder: (query) => query
              .where('down_date',
                  isGreaterThanOrEqualTo: startDate ?? DateTime(1900))
              .where('down_date',
                  isLessThanOrEqualTo: endDate ?? DateTime(2100))
              .orderBy('down_date')
              .orderBy("tag_number")
              .startAt(
            [widget.store.baixaAnimalPage],
          ),
        ),
        headings: [
          GenericDataSourceItem(
            'tag_number',
          ),
          GenericDataSourceItem(
            'down_reason',
            textAlign: TextAlign.center,
          ),
          GenericDataSourceItem(
            'down_date',
            type: TableItemType.date,
            textAlign: TextAlign.left,
          ),
        ],
        headingsTitle: const [
          DataColumn2(
            label: Center(
              child: Text(
                'Animal',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataColumn2(label: Center(child: Text('Motivo'))),
          DataColumn2(label: Center(child: Text('Data'))),
        ],
        noItemText: 'Nenhuma baixa encontrada.',
        screenshotController: widget.store.baixaAnimalScreenshot,
        controller: widget.store.baixaAnimalController,
        pageStart: widget.store.baixaAnimalPage,
        take: widget.store.baixaAnimalTake,
        onPageChanged: (page) {
          setState(() {
            widget.store.baixaAnimalPage = page;
          });
        },
        onSearchChanged: widget.store.startSearchTimerBaixa,
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
