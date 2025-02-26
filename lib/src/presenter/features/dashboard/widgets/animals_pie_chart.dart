import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnimalsPieChart extends StatefulWidget {
  final int maleAmount;
  final int femaleAmount;
  final double height;

  const AnimalsPieChart({
    super.key,
    this.maleAmount = 0,
    this.femaleAmount = 0,
    this.height = 300,
  });

  @override
  State<AnimalsPieChart> createState() => _AnimalsPieChartState();
}

class _AnimalsPieChartState extends State<AnimalsPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(height: widget.height),
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingSections(
                  widget.maleAmount.toDouble(),
                  widget.femaleAmount.toDouble(),
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Indicator(
              color: AppColors.primaryGreenDark,
              text: 'Macho (${widget.maleAmount.toString()})',
              textColor: const Color(0xFF57534E),
            ),
            const SizedBox(
              height: 4,
            ),
            Indicator(
              color: const Color(0xFFB5C9B8),
              text: 'Fêmea (${widget.femaleAmount.toString()})',
              textColor: const Color(0xFF57534E),
            ),
          ],
        ),
        const SizedBox(
          width: 28,
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(
      double maleAmount, double femaleAmount) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 60.0 : 50.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.primaryGreenDark,
            value: maleAmount,
            radius: radius,
            showTitle: false,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xFFB5C9B8),
            value: femaleAmount,
            radius: radius,
            showTitle: false,
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.size = 14,
    this.textColor,
  });
  final Color color;
  final String text;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: textColor,
          ),
        )
      ],
    );
  }
}
