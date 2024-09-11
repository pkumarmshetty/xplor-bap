import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';

/// Widget for displaying a line graph.
class LineGraphView extends StatelessWidget {
  const LineGraphView({super.key});

  final spots = const [
    FlSpot(0, 300),
    FlSpot(1, 1000),
    FlSpot(2, 1500),
    FlSpot(3, 600),
    FlSpot(4, 1500),
    FlSpot(5, 600),
  ];

  /// Bottom title widget for the line graph.
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final titles = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: titles[value.toInt()].titleSemiBold(color: AppColors.grey400, size: AppDimensions.smallXL.sp));
  }

  /// Left title widget for the line graph.
  Widget leftTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    return SideTitleWidget(
        axisSide: meta.axisSide,
        space: AppDimensions.large,
        child: meta.formattedValue.titleSemiBold(color: AppColors.grey400, size: AppDimensions.smallXL.sp));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  maxContentWidth: 100,
                  getTooltipColor: (touchedSpot) => Colors.black,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      const textStyle = TextStyle(
                        color: AppColors.grey100,
                        fontWeight: FontWeight.w500,
                        fontSize: AppDimensions.smallXXL,
                      );
                      const titleStyle = TextStyle(
                        color: AppColors.grey50,
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.smallXL,
                      );
                      return LineTooltipItem("${HomeKeys.seekers.stringToString}\n", textStyle,
                          children: [TextSpan(text: touchedSpot.y.toStringAsFixed(2).toString(), style: titleStyle)]);
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
                getTouchLineStart: (data, index) => 0,
              ),
              lineBarsData: [
                LineChartBarData(
                  color: AppColors.primaryColor,
                  spots: spots,
                  isCurved: true,
                  isStrokeCapRound: true,
                  barWidth: AppDimensions.extraSmall,
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                  dotData: const FlDotData(show: false),
                ),
              ],
              minY: 0,
              maxY: 1600,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta, constraints.maxWidth),
                    reservedSize: 56,
                  ),
                  drawBelowEverything: true,
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 18,
                    interval: 1,
                    getTitlesWidget: bottomTitleWidgets,
                  ),
                  drawBelowEverything: true,
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: 100,
                verticalInterval: 2000,
                checkToShowHorizontalLine: (value) {
                  return value.toInt() == 200 ||
                      value.toInt() == 400 ||
                      value.toInt() == 600 ||
                      value.toInt() == 800 ||
                      value.toInt() == 1000 ||
                      value.toInt() == 1200 ||
                      value.toInt() == 1400 ||
                      value.toInt() == 1600 ||
                      value.toInt() == 1800 ||
                      value.toInt() == 2000;
                },
                getDrawingHorizontalLine: (_) => const FlLine(
                  color: AppColors.grey100,
                  dashArray: [8, 0],
                  strokeWidth: 0.8,
                ),
                getDrawingVerticalLine: (_) => FlLine(
                  color: AppColors.primaryColor.withOpacity(1),
                  dashArray: [8, 2],
                  strokeWidth: 0.8,
                ),
                checkToShowVerticalLine: (value) {
                  return value.toInt() == 1;
                },
              ),
              borderData: FlBorderData(show: false),
            ),
          );
        },
      ),
    ).symmetricPadding(vertical: AppDimensions.medium);
  }
}
