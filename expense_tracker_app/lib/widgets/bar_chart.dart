import 'package:expense_tracker_app/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MainBarChart extends StatefulWidget {
  const MainBarChart({super.key});

  @override
  State<MainBarChart> createState() => _MainBarChartState();
}

class _MainBarChartState extends State<MainBarChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: BarChart(
        mainChartData(),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  BarChartData mainChartData() {
    return BarChartData(
      maxY: 6,
      minY: 0,

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.divider.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),

      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider.withValues(alpha: 0.5),
            width: 1,
          ),
          left: BorderSide(
            color: AppColors.divider.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),

      barGroups: [
        makeGroupData(0, 3),
        makeGroupData(1, 4.5),
        makeGroupData(2, 2),
        makeGroupData(3, 5),
        makeGroupData(4, 3.5),
        makeGroupData(5, 4),
        makeGroupData(6, 2.5),
        makeGroupData(7, 5.5),
      ],

      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1,
            getTitlesWidget: leftTitles,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: getTitles,
          ),
        ),
      ),

      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => AppColors.primary,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              'Rp ${(rod.toY * 1000).toStringAsFixed(0)}',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
    );
  }

  // ✅ FIXED: Bottom titles (X-axis)
  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );

    String text = switch (value.toInt()) {
      0 => '01',
      1 => '02',
      2 => '03',
      3 => '04',
      4 => '05',
      5 => '06',
      6 => '07',
      7 => '08',
      _ => '',
    };

    // ✅ CORRECT: Remove axisSide parameter
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  // ✅ FIXED: Left titles (Y-axis)
  Widget leftTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );

    String text = switch (value.toInt()) {
      0 => '0',
      1 => '1K',
      2 => '2K',
      3 => '3K',
      4 => '4K',
      5 => '5K',
      6 => '6K',
      _ => '',
    };

    // ✅ CORRECT: Remove axisSide parameter
    return SideTitleWidget(
      meta: meta,
      // ✅ Positional parameter
      child: Text(text, style: style),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.tertiary,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 15,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 6,
            color: AppColors.divider.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}
