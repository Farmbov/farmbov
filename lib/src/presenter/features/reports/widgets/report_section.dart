import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/features/reports/reports_page_store.dart';
import 'package:farmbov/src/presenter/features/reports/widgets/datasources/rect_range_slider_thumb.dart';
import 'package:farmbov/src/presenter/shared/components/widget_default_loader.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:screenshot/screenshot.dart';

import 'package:farmbov/src/presenter/features/home/widgets/section_action_button.dart';
import 'package:farmbov/src/presenter/features/reports/widgets/datasources/generic_datasource.dart';

// Based on this
// https://github.com/maxim-saplin/data_table_2/blob/4c8c33b90aa9bd57259de50dd660b4ded828e309/example/lib/screens/async_paginated_data_table2.dart

class ReportSection extends StatefulWidget {
  final ReportsPageStore store;
  final String title;
  final Future<List<dynamic>> Function(
      DateTime?, DateTime?, String? handlingType)? futureData;
  final Future<int> Function(DateTime?, DateTime?, String? handlingType)?
      futureCount;
  final List<GenericDataSourceItem> headings;
  final List<DataColumn2> headingsTitle;
  final String noItemText;
  final TextEditingController? controller;
  final void Function(String)? onSearchChanged;
  final void Function(int)? onPageChanged;
  final int pageStart;
  final int take;
  final ScreenshotController? screenshotController;
  final GlobalKey? rangeSelectorKey;
  final String dateRangeTitle;
  final bool showHandlingTypeFilter;
  final String? handlingType;
  final Function(String)? onHandlingTypeChanged;

  const ReportSection({
    super.key,
    required this.store,
    required this.title,
    required this.futureData,
    required this.futureCount,
    required this.headings,
    required this.headingsTitle,
    this.noItemText = "Nenhum item encontrado",
    this.controller,
    this.onSearchChanged,
    this.onPageChanged,
    this.pageStart = 0,
    this.take = 8,
    this.screenshotController,
    this.rangeSelectorKey,
    this.dateRangeTitle = "Período",
    this.showHandlingTypeFilter = false,
    this.handlingType,
    this.onHandlingTypeChanged,
  });

  @override
  ReportSectionState createState() => ReportSectionState();
}

class ReportSectionState extends State<ReportSection> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final _sortAscending = true;
  int? _sortColumnIndex;
  GenericDataSourceAsync? _dataSource;
  final PaginatorController _controller = PaginatorController();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _handlingType;

  @override
  void didChangeDependencies() {
    setState(() {
      _handlingType = widget.handlingType;
    });
    _dataSource = GenericDataSourceAsync(
      widget.headings,
      futureData: widget.futureData,
      futureCount: widget.futureCount,
    );
    super.didChangeDependencies();
  }

  // TODO: ...
  // void sort(
  //   int columnIndex,
  //   bool ascending,
  // ) {
  //   var columnName = "name";
  //   switch (columnIndex) {
  //     case 1:
  //       columnName = "calories";
  //       break;
  //     case 2:
  //       columnName = "fat";
  //       break;
  //     case 3:
  //       columnName = "carbs";
  //       break;
  //     case 4:
  //       columnName = "protein";
  //       break;
  //     case 5:
  //       columnName = "sodium";
  //       break;
  //     case 6:
  //       columnName = "calcium";
  //       break;
  //     case 7:
  //       columnName = "iron";
  //       break;
  //   }
  //   _dessertsDataSource!.sort(columnName, ascending);
  //   setState(() {
  //     _sortColumnIndex = columnIndex;
  //     _sortAscending = ascending;
  //   });
  // }

  @override
  void dispose() {
    _dataSource?.dispose();
    super.dispose();
  }

  Widget _filterSection(BuildContext context) {
    return Row(
      children: [
        if (widget.showHandlingTypeFilter) ...[
          SizedBox(
            width: 150,
            child: DropdownSearch<String>(
              items: const [
                'Todos',
                'Reprodutivo',
                'Sanitário',
                'Pesagem',
              ],
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Tipo de manejo',
                  fillColor: Colors.transparent,
                ),
              ),
              onChanged: (String? item) {
                setState(() {
                  _handlingType = item;
                  _dataSource?.refreshHandlingType(item);
                  widget.onHandlingTypeChanged?.call(item!);
                });
              },
              selectedItem: widget.handlingType ?? 'Todos',
            ),
          ),
          const SizedBox(width: 10),
        ],
        _filterToggle(
          context,
          title: 'Período',
          icon: Icons.date_range_outlined,
        ),
      ],
    );
  }

  Widget _sectionTitle(
    BuildContext context,
    String title, {
    TextEditingController? controller,
    void Function(String)? onSearchChanged,
  }) {
    final List<Widget> listFilters = [
      Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF292524),
                ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 24),
        ],
      ),
      _filterSection(context),
    ];

    return Padding(
        padding: ResponsiveBreakpoints.of(context).isMobile
            ? const EdgeInsets.all(20)
            : const EdgeInsets.all(0),
        child: ResponsiveBreakpoints.of(context).isMobile
            ? Wrap(
                children: [...listFilters],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [...listFilters],
              ));
  }

  Widget _filterToggle(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () async {
        final pickedDateRange = await showDateRangePicker(
          context: context,
          // TODO: improve (usar menor e maior valor do banco)
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          helpText: widget.dateRangeTitle,
          initialEntryMode: DatePickerEntryMode.inputOnly,
          initialDateRange: _startDate != null && _endDate != null
              ? DateTimeRange(start: _startDate!, end: _endDate!)
              : null,
        );

        if (pickedDateRange != null) {
          setState(() {
            _startDate = pickedDateRange.start;
            _endDate = pickedDateRange.end;
            _dataSource?.refreshDateRange(_startDate, _endDate);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFD7D3D0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.lightGray,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          context,
          widget.title,
          controller: widget.controller,
          onSearchChanged: widget.onSearchChanged,
        ),
        const SizedBox(height: 10),
        Screenshot(
          controller: widget.screenshotController!,
          child: SizedBox(
            height: 500,
            child: AsyncPaginatedDataTable2(
              checkboxHorizontalMargin: 12,
              showCheckboxColumn: false,
              horizontalMargin: 30,
              columnSpacing: 0,
              wrapInCard: false,
              rowsPerPage: _rowsPerPage,
              pageSyncApproach: PageSyncApproach.doNothing,
              // minWidth: 500,
              source: _dataSource!,

              fit: FlexFit.tight,
              border: TableBorder(
                top: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
                left: BorderSide(color: Colors.grey[300]!),
                right: BorderSide(color: Colors.grey[300]!),
                verticalInside: BorderSide(color: Colors.grey[300]!),
                horizontalInside:
                    const BorderSide(color: Colors.grey, width: 1),
              ),
              onRowsPerPageChanged: (value) => _rowsPerPage = value!,
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              sortArrowIcon: Icons.keyboard_arrow_up,
              sortArrowAnimationDuration: const Duration(milliseconds: 0),
              controller: _controller,
              columns: widget.headingsTitle,
              empty: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey[200],
                  child: Text(widget.noItemText),
                ),
              ),
              loading: const WidgetDefaultLoader(),
              errorBuilder: (e) => _ErrorAndRetry(
                e.toString(),
                () => _dataSource?.refreshDatasource(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (widget.screenshotController != null) ...[
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: SectionActionButton(
                title: 'Baixar relatório',
                width: 170,
                icon: Icons.download_outlined,
                onPressed: () => widget.store.saveWidgetAsPdf(
                  context,
                  widget.screenshotController!,
                  reportTitle: widget.title,
                  startDate: _startDate,
                  endDate: _endDate,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ErrorAndRetry extends StatelessWidget {
  const _ErrorAndRetry(this.errorMessage, this.retry);

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 70,
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Oops! Ocorreu um erro.',
                  style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: retry,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    Text('Tentar novamente',
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _TitledRangeSelector extends StatefulWidget {
  const _TitledRangeSelector({
    required this.onChanged,
    required this.title,
    required this.caption,
    required this.range,
  });

  final String title;
  final String caption;
  final Duration titleToSelectorSwitch = const Duration(seconds: 2);
  final RangeValues range;
  final Function(RangeValues) onChanged;

  @override
  State<_TitledRangeSelector> createState() => _TitledRangeSelectorState();
}

class _TitledRangeSelectorState extends State<_TitledRangeSelector> {
  bool _titleVisible = true;
  RangeValues _values = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();

    _values = widget.range;

    Timer(
        widget.titleToSelectorSwitch,
        () => setState(() {
              _titleVisible = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AnimatedOpacity(
            opacity: _titleVisible ? 1 : 0,
            duration: const Duration(milliseconds: 1000),
            child: Align(
                alignment: Alignment.centerLeft, child: Text(widget.title))),
        AnimatedOpacity(
          opacity: _titleVisible ? 0 : 1,
          duration: const Duration(milliseconds: 1000),
          child: SizedBox(
            width: 340,
            child: Theme(
              data: blackSlider(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _values.start.toStringAsFixed(0),
                          ),
                          Text(
                            widget.caption,
                          ),
                          Text(
                            _values.end.toStringAsFixed(0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    child: RangeSlider(
                      values: _values,
                      divisions: 9,
                      min: widget.range.start,
                      max: widget.range.end,
                      onChanged: (v) {
                        setState(() {
                          _values = v;
                        });
                        widget.onChanged(v);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GenericDataSourceAsync<T> extends AsyncDataTableSource {
  final List<GenericDataSourceItem> headings;
  final Future<List<dynamic>> Function(
      DateTime?, DateTime?, String? handlingType)? futureData;
  final Future<int> Function(DateTime?, DateTime?, String? handlingType)?
      futureCount;

  GenericDataSourceAsync(
    this.headings, {
    required this.futureData,
    required this.futureCount,
  });

  int? _errorCounter;

  DateTime? _startDate;
  DateTime? _endDate;
  String? _handlingType;

  void refreshDateRange(DateTime? startDate, DateTime? endDate) {
    _startDate = startDate;
    _endDate = endDate;
    refreshDatasource();
  }

  void refreshHandlingType(String? handlingType) {
    _handlingType = handlingType;
    refreshDatasource();
  }

  Future<int> getTotalRecords() async =>
      await futureCount!(_startDate, _endDate, _handlingType);

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    if (_errorCounter != null) {
      _errorCounter = _errorCounter! + 1;

      if (_errorCounter! % 2 == 1) {
        await Future.delayed(const Duration(milliseconds: 1000));
        throw 'Error #${((_errorCounter! - 1) / 2).round() + 1} has occured';
      }
    }

    var index = startIndex;

    assert(index >= 0);

    final total = await getTotalRecords();
    if (total == 0) {
      return AsyncRowsResponse(0, []);
    }

    final data = await futureData!(_startDate, _endDate, _handlingType);

    return AsyncRowsResponse(
      total,
      data
          .map(
            (item) => DataRow(
              cells: GenericDataSource(headings, data: item).cells(),
            ),
          )
          .toList(),
    );
  }
}
