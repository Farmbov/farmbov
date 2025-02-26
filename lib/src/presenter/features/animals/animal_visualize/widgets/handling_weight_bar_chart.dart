import 'package:farmbov/src/common/helpers/localization_helper.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/models/firestore/animal_handling_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import "package:collection/collection.dart";

class AnimalIndex {
  int index;
  double weight;

  AnimalIndex(
    this.index, {
    this.weight = 0,
  });
}

class HandlingWeightBarChart extends StatefulWidget {
  final List<AnimalHandlingModel> manejoPesagem;

  const HandlingWeightBarChart({
    super.key,
    required this.manejoPesagem,
  });

  @override
  State<HandlingWeightBarChart> createState() => _HandlingWeightBarChartState();
}

class _HandlingWeightBarChartState extends State<HandlingWeightBarChart> {
  Widget bottomTitlesAnual(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt() + 1) {
      case 1:
        text = 'Jan';
        break;
      case 2:
        text = 'Fev';
        break;
      case 3:
        text = 'Mar';
        break;
      case 4:
        text = 'Abr';
        break;
      case 5:
        text = 'Mai';
        break;
      case 6:
        text = 'Jun';
        break;
      case 7:
        text = 'Jul';
        break;
      case 8:
        text = 'Aug';
        break;
      case 9:
        text = 'Set';
        break;
      case 10:
        text = 'Ago';
        break;
      case 11:
        text = 'Nov';
        break;
      case 12:
        text = 'Dez';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  List<AnimalIndex> animalIndex = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _resetList();
  }

  void _resetList() {
    setState(() {
      animalIndex = List.generate(12, (index) => AnimalIndex(index + 1));
    });
  }

  void _calculate() {
    _resetList();

    int year = DateTime.now().year;

    groupBy(
      widget.manejoPesagem.where((a) => a.handlingDate?.year == year),
      (obj) => obj.handlingDate?.month,
    ).forEach((month, animal) {
      setState(() {
        final weight = animal.lastOrNull?.weight;
        final parsedWeight = LocalizationHelper.parseDouble(weight!);
        animalIndex[_getCurrentMonthIndex(month)].weight = parsedWeight;
      });
    });
  }

  int _getCurrentMonthIndex(mes) => (mes ?? 0) - 1;

  @override
  Widget build(BuildContext context) {
    _calculate();

    return AspectRatio(
      aspectRatio: 1.66,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barsSpace = constraints.maxWidth / 25;
          final barsWidth = constraints.maxWidth / 30;
          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: bottomTitlesAnual,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10,
                    getTitlesWidget: leftTitles,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 100 == 0,
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: Colors.black54,
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: barsSpace,
              barGroups: getData(context, barsWidth, barsSpace),
            ),
          );
        },
      ),
    );
  }

  List<BarChartGroupData> getData(
    BuildContext context,
    double barsWidth,
    double barsSpace,
  ) {
    const normalColor = AppColors.primaryGreen;

    return List.generate(
      12,
      (index) => BarChartGroupData(
        x: index,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: animalIndex.elementAtOrNull(index) == null
                ? 0
                : animalIndex.elementAtOrNull(index)!.weight.toDouble(),
            borderRadius: BorderRadius.circular(6),
            width: barsWidth,
            color: normalColor,
          ),
        ],
      ),
    );
  }
}
