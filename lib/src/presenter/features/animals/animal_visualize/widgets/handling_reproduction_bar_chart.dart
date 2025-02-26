import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../common/themes/theme_constants.dart';

class LegendWidget extends StatelessWidget {
  const LegendWidget({
    super.key,
    required this.name,
    required this.color,
  });
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff757391),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class LegendsListWidget extends StatelessWidget {
  const LegendsListWidget({
    super.key,
    required this.legends,
  });
  final List<Legend> legends;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
              name: e.name,
              color: e.color,
            ),
          )
          .toList(),
    );
  }
}

class Legend {
  Legend(this.name, this.color);
  final String name;
  final Color color;
}

class YearNotifier extends ValueNotifier<int> {
  YearNotifier(super.initialYear);

  void updateYear(int newYear) {
    if (value != newYear) {
      value = newYear;
    }
  }
}

class HandlingReproductionBarChart extends StatefulWidget {
  final String farmId;

  const HandlingReproductionBarChart({
    super.key,
    required this.farmId,
  });

  @override
  State<HandlingReproductionBarChart> createState() =>
      _HandlingReproductionBarChartState();
}

class _HandlingReproductionBarChartState
    extends State<HandlingReproductionBarChart> {
  final YearNotifier _yearNotifier = YearNotifier(DateTime.now().year);
  List<int> _availableYears = [];
  List<int> _entries = List.filled(12, 0);
  List<int> _exits = List.filled(12, 0);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final entryExitDoc = await FirebaseFirestore.instance
        .doc('farms/${widget.farmId}/farm_statistics/entry_exit')
        .get();

    _availableYears = List<int>.from(
      entryExitDoc.data()?['available_years'] ?? [],
    )..sort();

    if (_availableYears.isNotEmpty) {
      _yearNotifier.value = _availableYears.last;
      _loadYearData(_yearNotifier.value);
    }
  }

  Future<void> _loadYearData(int year) async {
    final yearDoc = await FirebaseFirestore.instance
        .doc('farms/${widget.farmId}/farm_statistics/entry_exit/years/$year')
        .get();

    // Passo 1: Obter os meses como mapa (ex: {'0': {entries: 1, exits: 0}, ...})
    final Map<String, dynamic> monthsData =
        (yearDoc.data()?['months'] as Map? ?? <String, dynamic>{})
            .map((key, value) => MapEntry(key, value ?? {}));

    // Passo 2: Converter o mapa para uma lista ordenada (índices 0-11)
    final orderedMonths = List<Map<String, dynamic>>.generate(12, (index) {
      final key = index.toString();
      return {
        'entries': (monthsData[key]?['entries'] ?? 0).toInt(),
        'exits': (monthsData[key]?['exits'] ?? 0).toInt(),
      };
    });

    setState(() {
      _entries = orderedMonths.map((e) => e['entries'] as int).toList();
      _exits = orderedMonths.map((e) => e['exits'] as int).toList();
    });
  }

  List<BarChartGroupData> _buildChartGroups() {
    return List.generate(
        12,
        (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: _entries[index].toDouble(),
                  color: AppColors.primaryGreen,
                  width: 5,
                ),
                BarChartRodData(
                  fromY: 0,
                  toY: _exits[index].toDouble(),
                  color: AppColors.errorColor,
                  width: 5,
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _yearNotifier,
      builder: (context, year, child) {
        return FutureBuilder<void>(
          future: _loadYearData(year),
          builder: (context, snapshot) {
            return Column(
              children: [
                _buildYearSelector(),
                _buildAnimatedChart(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildYearSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text("Ano:", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          DropdownButton<int>(
            value: _yearNotifier.value,
            items: _availableYears.map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            onChanged: (newYear) {
              if (newYear != null) {
                _yearNotifier.updateYear(newYear);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedChart() {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (BarChartGroupData groupData) {
                return groupData.showingTooltipIndicators.first == 0
                    ? AppColors.primaryGreen
                    : AppColors.errorColor;
              },
              getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                  BarTooltipItem(
                '${rod.toY.toInt()} ${rodIndex == 0 ? 'Entradas' : 'Baixas'}',
                const TextStyle(color: Colors.white),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => _buildMonthTitle(value),
                reservedSize: 20,
              ),
            ),
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: _buildChartGroups()
              .map((group) => BarChartGroupData(
                    x: group.x,
                    barRods: group.barRods
                        .map((rod) => BarChartRodData(
                              fromY: rod.fromY,
                              toY: rod.toY,
                              color: rod.color,
                              width: rod.width,
                            ))
                        .toList(),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildMonthTitle(double value) {
    const style = TextStyle(fontSize: 10);
    const months = [
      'JAN',
      'FEV',
      'MAR',
      'ABR',
      'MAI',
      'JUN',
      'JUL',
      'AGO',
      'SET',
      'OUT',
      'NOV',
      'DEZ'
    ];
    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      child: Text(months[value.toInt()], style: style),
    );
  }

  @override
  void dispose() {
    _yearNotifier.dispose();
    super.dispose();
  }
}
