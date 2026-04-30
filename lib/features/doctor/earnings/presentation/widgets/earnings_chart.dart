import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/features/doctor/earnings/domain/entities/earnings.dart';
import 'package:tabibi/features/doctor/earnings/presentation/utils/earnings_formatters.dart';

class EarningsChart extends StatelessWidget {
  final List<ChartDataPoint> data;

  const EarningsChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxAmount = data.fold<double>(
      0,
      (previous, point) => math.max(previous, point.amount),
    );
    final chartMaxY = maxAmount <= 0 ? 100.0 : maxAmount * 1.25;

    return SizedBox(
      height: 240.h,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: chartMaxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: chartMaxY / 4,
            getDrawingHorizontalLine: (value) {
              return const FlLine(color: AppColors.grey200, strokeWidth: 1);
            },
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 46.w,
                getTitlesWidget: (value, meta) => Text(
                  EarningsFormatters.compactMoney(value),
                  style: TextStyle(color: AppColors.grey500, fontSize: 10.sp),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      data[index].label,
                      style: TextStyle(
                        color: AppColors.grey500,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map(
                    (entry) => FlSpot(entry.key.toDouble(), entry.value.amount),
                  )
                  .toList(),
              isCurved: true,
              color: AppColors.teal,
              barWidth: 4,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.teal,
                    strokeWidth: 3,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.teal.withValues(alpha: 0.10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
