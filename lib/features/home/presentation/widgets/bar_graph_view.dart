import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_colors.dart';

/// BarGraphView Page
class BarGraphView extends StatefulWidget {
  const BarGraphView({super.key});

  @override
  State<BarGraphView> createState() => _BarGraphViewState();
}

class _BarGraphViewState extends State<BarGraphView> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(22, 5, Colors.red.withOpacity(0.8));
    final barGroup2 = makeGroupData(23, 16, Colors.black.withOpacity(0.8));
    final barGroup3 = makeGroupData(24, 18, Colors.blue.withOpacity(0.8));
    final barGroup4 = makeGroupData(25, 20, Colors.amber.withOpacity(0.8));
    final barGroup5 = makeGroupData(25, 17, Colors.blue.withOpacity(0.8));
    final barGroup6 = makeGroupData(27, 19, Colors.red.withOpacity(0.8));
    final barGroup7 = makeGroupData(28, 10, Colors.blue.withOpacity(0.8));

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
          padding: const EdgeInsets.all(AppDimensions.medium),
          child: BarChart(
            BarChartData(
              maxY: 20,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: ((group) {
                    return Colors.grey;
                  }),
                  getTooltipItem: (a, b, c, d) => null,
                ),
                touchCallback: (FlTouchEvent event, response) {
                  if (response == null || response.spot == null) {
                    setState(() {
                      touchedGroupIndex = -1;
                      showingBarGroups = List.of(rawBarGroups);
                    });
                    return;
                  }

                  touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                  setState(() {
                    if (!event.isInterestedForInteractions) {
                      touchedGroupIndex = -1;
                      showingBarGroups = List.of(rawBarGroups);
                      return;
                    }
                    showingBarGroups = List.of(rawBarGroups);
                    if (touchedGroupIndex != -1) {
                      var sum = 0.0;
                      for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
                        sum += rod.toY;
                      }
                      final avg = sum / showingBarGroups[touchedGroupIndex].barRods.length;

                      showingBarGroups[touchedGroupIndex] = showingBarGroups[touchedGroupIndex].copyWith(
                        barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                          return rod.copyWith(toY: avg, color: AppColors.primaryDarkColor);
                        }).toList(),
                      );
                    }
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: bottomTitles,
                    reservedSize: 42,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: leftTitles,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: showingBarGroups,
              gridData: const FlGridData(show: false),
            ),
          )),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.greyTextColor,
      fontWeight: FontWeight.w500,
      fontSize: AppDimensions.smallXXL,
    );
    String text;
    if (value == 0) {
      text = '₹1';
    } else if (value == 5) {
      text = '₹5';
    } else if (value == 10) {
      text = '₹10';
    } else if (value == 15) {
      text = '₹15';
    } else if (value == 20) {
      text = '₹20';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text = Text(
      value.toString(),
      style: const TextStyle(
        color: AppColors.greyTextColor,
        fontWeight: FontWeight.w500,
        fontSize: AppDimensions.smallXXL,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: AppDimensions.medium, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, Color color) {
    return BarChartGroupData(
      barsSpace: AppDimensions.extraSmall,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: color,
          width: 30,
        ),
      ],
    );
  }
}
