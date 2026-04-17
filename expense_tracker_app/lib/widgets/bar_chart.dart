import 'package:expense_tracker_app/models/expense_category.dart';
import 'package:expense_tracker_app/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MainBarChart extends StatelessWidget {
  final Map<String, double> categoryTotals;

  const MainBarChart({super.key, required this.categoryTotals});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: BarChart(
            _mainChartData(),
            duration: const Duration(milliseconds: 300),
          ),
        );
      },
    );
  }

  BarChartData _mainChartData() {
    // ✅ Get max value untuk scaling
    final maxValue = categoryTotals.values.isEmpty
        ? 100000.0
        : categoryTotals.values.reduce((a, b) => a > b ? a : b);

    return BarChartData(
      maxY: maxValue * 1.2, // 20% padding di atas
      minY: 0,
      barTouchData: _barTouchData(),
      titlesData: _titlesData(),
      borderData: _borderData(),
      gridData: _gridData(),
      barGroups: _barGroups(),
      alignment: BarChartAlignment.spaceAround,
    );
  }

  // ✅ Bar Groups dengan data real
  List<BarChartGroupData> _barGroups() {
    final categories = ExpenseCategory.getAllCategory();

    return List.generate(categories.length, (index) {
      final category = categories[index];
      final amount = categoryTotals[category] ?? 0.0;
      final color = _getCategoryColor(category);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 24,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: categoryTotals.values.isEmpty
                  ? 100000
                  : categoryTotals.values.reduce((a, b) => a > b ? a : b) * 1.2,
              color: AppColors.divider.withValues(alpha: 0.3),
            ),
          ),
        ],
      );
    });
  }

  // ✅ Touch Data dengan tooltip
  BarTouchData _barTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        // tooltipBgColor: AppColors.surface,
        tooltipPadding: const EdgeInsets.all(8),
        tooltipMargin: 8,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final categories = ExpenseCategory.getAllCategory();

          if (groupIndex >= categories.length) {
            return null; // Prevent out of bounds
          }

          final category = categories[groupIndex];
          final amount = rod.toY;

          return BarTooltipItem(
            '$category\n',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: 'Rp ${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final categories = ExpenseCategory.getAllCategory();

            if (value.toInt() >= 0 && value.toInt() < categories.length) {
              // Ambil huruf pertama
              final label = categories[value.toInt()][0];
              return SideTitleWidget(
                meta: meta,
                // axisSide: meta.axisSide,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlBorderData _borderData() {
    return FlBorderData(show: false);
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: 50000,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: AppColors.divider.withValues(alpha: 0.3),
          strokeWidth: 1,
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    return AppColors.getCategoryColor(category);
  }
}
