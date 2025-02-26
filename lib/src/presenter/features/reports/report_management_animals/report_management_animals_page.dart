import 'package:data_table_2/data_table_2.dart';
import 'package:diacritic/diacritic.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/presenter/features/reports/reports_page_store.dart';

import 'package:farmbov/src/presenter/features/reports/widgets/datasources/generic_datasource.dart';
import 'package:farmbov/src/presenter/features/reports/widgets/report_section.dart';
import 'package:farmbov/src/presenter/features/reports/report_management_animals/report_management_animals_page_store.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ReportManagementAnimalsPage extends StatefulWidget {
  final ReportManagementAnimalsPageStore store;
  final ReportsPageStore baseStore;

  const ReportManagementAnimalsPage({
    super.key,
    required this.store,
    required this.baseStore,
  });

  @override
  ReportManagementAnimalsPageState createState() =>
      ReportManagementAnimalsPageState();
}

class ReportManagementAnimalsPageState
    extends State<ReportManagementAnimalsPage> {
  String _handlingType = 'Todos';

  @override
  void initState() {
    super.initState();
    widget.store.init();
    _tables.add(_buildContent(context));
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

  Query<Object?> _defaultQuery(
    DateTime? startDate,
    DateTime? endDate,
    Query<Object?> query,
  ) {
    return query
        .where('handling_date',
            isGreaterThanOrEqualTo: startDate ?? DateTime(1900))
        .where('handling_date', isLessThanOrEqualTo: endDate ?? DateTime(2100))
        .orderBy('handling_date')
        .startAt(
      [widget.store.baixaAnimalPage],
    );
  }

  Query<Object?> _buildQuery(
    DateTime? startDate,
    DateTime? endDate,
    String? handlingType,
    Query<Object?> defaultQuery,
  ) {
    final query = _defaultQuery(startDate, endDate, defaultQuery);

    if (handlingType != null &&
        handlingType.isNotEmpty &&
        handlingType != 'Todos') {
      return query.where('handling_type',
          isEqualTo: removeDiacritics(handlingType.toLowerCase()));
    }
    return query;
  }

  final List<Widget> _tables = [];

  // SORRY for this (gambiarra)
  void _onHandlingTypeChanged(BuildContext context, String type) {
    setState(() {
      _handlingType = type;
      _tables.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (type == 'Reprodutivo') {
          _tables.add(_buildReproductiveManangement(context));
        } else if (type == 'Pesagem') {
          _tables.add(_buildWeighingManangment(context));
        } else if (type == 'Sanitário') {
          _tables.add(_buildSanitaryManagement(context));
        } else {
          _tables.add(_buildContent(context));
        }
      });
    });
  }

  Widget _buildSanitaryManagement(BuildContext context) => ReportSection(
        title: 'Relatório de manejo sanitário',
        store: widget.baseStore,
        dateRangeTitle: 'Data do manejo sanitário',
        showHandlingTypeFilter: true,
        handlingType: _handlingType,
        futureData: (startDate, endDate, handlingType) => queryManejoRecordOnce(
          queryBuilder: (query) =>
              _buildQuery(startDate, endDate, 'sanitario', query),
        ),
        futureCount: (startDate, endDate, handlingType) =>
            queryManejoRecordCount(
          queryBuilder: (query) =>
              _buildQuery(startDate, endDate, 'sanitario', query),
        ),
        headings: [
          GenericDataSourceItem('tag_number', textAlign: TextAlign.center),
          GenericDataSourceItem('vaccine', textAlign: TextAlign.center),
          GenericDataSourceItem(
            'handling_date',
            type: TableItemType.date,
            textAlign: TextAlign.center,
          ),
        ],
        headingsTitle: const [
          DataColumn2(label: Text('Número do brinco')),
          DataColumn2(label: Text('Vacina')),
          DataColumn2(
            label: Text(
              'Data do manejo',
              textAlign: TextAlign.center,
            ),
          ),
        ],
        noItemText: 'Nenhum manejo sanitário encontrado.',
        screenshotController: widget.store.manejoScreenshot,
        controller: widget.store.manejoController,
      );

  Widget _buildWeighingManangment(BuildContext context) => ReportSection(
        title: 'Relatório de pesagem',
        store: widget.baseStore,
        dateRangeTitle: 'Data da pesagem',
        showHandlingTypeFilter: false,
        futureData: (startDate, endDate, handlingType) => queryManejoRecordOnce(
          queryBuilder: (query) =>
              _buildQuery(startDate, endDate, 'pesagem', query),
        ),
        futureCount: (startDate, endDate, handlingType) =>
            queryManejoRecordCount(
          queryBuilder: (query) =>
              _buildQuery(startDate, endDate, 'pesagem', query),
        ),
        headings: [
          GenericDataSourceItem('tag_number'),
          GenericDataSourceItem(
            'weight',
            type: TableItemType.number,
            textAlign: TextAlign.right,
          ),
          GenericDataSourceItem(
            'weighing_date',
            type: TableItemType.date,
            textAlign: TextAlign.right,
          ),
        ],
        headingsTitle: const [
          DataColumn2(label: Text('Número do brinco')),
          DataColumn2(label: Text('Peso')),
          DataColumn2(label: Text('Data da pesagem')),
        ],
        noItemText: 'Nenhuma pesagem encontrada.',
        screenshotController: widget.store.manejoScreenshot,
        controller: widget.store.manejoController,
      );

  // TODO: trocar tudo de handling para manangment
  Widget _buildReproductiveManangement(BuildContext context) => ReportSection(
        title: 'Relatório de manejo reprodutivo',
        store: widget.baseStore,
        dateRangeTitle: 'Data do manejo reprodutivo',
        showHandlingTypeFilter: true,
        handlingType: _handlingType,
        futureData: (startDate, endDate, handlingType) => queryManejoRecordOnce(
          queryBuilder: (query) =>
              _buildQuery(startDate, endDate, 'reprodutivo', query),
        ),
        futureCount: (startDate, endDate, handlingType) =>
            queryManejoRecordCount(
          queryBuilder: (query) =>
              _buildQuery(startDate, endDate, 'reprodutivo', query),
        ),
        headings: [
          GenericDataSourceItem('tag_number'),
          GenericDataSourceItem('isPregnant', textAlign: TextAlign.center),
          GenericDataSourceItem(
            'pregnant_date',
            type: TableItemType.date,
            textAlign: TextAlign.right,
          ),
          GenericDataSourceItem(
            'handling_date',
            type: TableItemType.date,
            textAlign: TextAlign.right,
          ),
        ],
        headingsTitle: const [
          DataColumn2(label: Text('Número do brinco')),
          DataColumn2(label: Text('Prenha')),
          DataColumn2(label: Text('Data prenha')),
          DataColumn2(label: Text('Data do manejo')),
        ],
        noItemText: 'Nenhum manejo reprodutivo encontrado.',
        screenshotController: widget.store.manejoScreenshot,
        controller: widget.store.manejoController,
        // TODO: pagination not working
        pageStart: widget.store.manejoPage,
        take: widget.store.manejoTake,
        onPageChanged: (page) {
          setState(() {
            widget.store.manejoPage = page;
          });
        },
        onSearchChanged: widget.store.startSearchTimerManejo,
        onHandlingTypeChanged: (type) => _onHandlingTypeChanged(context, type),
      );

  Widget _buildContent(BuildContext context) => ReportSection(
        title: 'Relatório de manejo',
        store: widget.baseStore,
        dateRangeTitle: 'Data da manejo',
        showHandlingTypeFilter: true,
        handlingType: _handlingType,
        futureData: (startDate, endDate, handlingType) => queryManejoRecordOnce(
          queryBuilder: (query) =>
              _buildQuery(startDate, endDate, _handlingType, query),
        ),
        futureCount: (startDate, endDate, handlingType) =>
            queryManejoRecordCount(
          queryBuilder: (query) =>
              _buildQuery(startDate, endDate, _handlingType, query),
        ),
        headings: [
          GenericDataSourceItem('tag_number'),
          GenericDataSourceItem('handling_type', textAlign: TextAlign.center),
          GenericDataSourceItem(
            'handling_date',
            type: TableItemType.date,
            textAlign: TextAlign.right,
          ),
        ],

        headingsTitle: const [
          DataColumn2(label: Center(child: Text('Animal'))),
          DataColumn2(label: Center(child: Text('Manejo'))),
          DataColumn2(label: Center(child: Text('Data'))),
        ],
        noItemText: 'Nenhum manejo encontrado.',
        screenshotController: widget.store.manejoScreenshot,
        controller: widget.store.manejoController,
        // TODO: pagination not working
        pageStart: widget.store.manejoPage,
        take: widget.store.manejoTake,
        onPageChanged: (page) {
          setState(() {
            widget.store.manejoPage = page;
          });
        },
        onSearchChanged: widget.store.startSearchTimerManejo,
        rangeSelectorKey: GlobalKey(),
        onHandlingTypeChanged: (type) => _onHandlingTypeChanged(context, type),
      );

  @override
  Widget build(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile
          ? Column(children: _tables)
          : GenericPageContent(
              title: 'Relatórios',
              useGridRows: false,
              padding: _getPadding(context),
              titlePadding: _getTitlePadding(context),
              children: _tables,
            );
}
