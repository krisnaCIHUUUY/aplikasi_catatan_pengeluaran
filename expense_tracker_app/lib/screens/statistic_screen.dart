import 'dart:developer';

import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/widgets/expense_page.dart';
import 'package:expense_tracker_app/widgets/income_page.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  int? selectedIndex = 0;

  Widget _onToggle() {
    switch (selectedIndex) {
      case 0:
        return IncomePage();

      case 1:
        return ExpensePage();

      default:
        return IncomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Transaksi", style: textTheme.displayMedium),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.more_vert_outlined),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ToggleSwitch(
              minWidth: double.infinity,
              minHeight: 50,
              cornerRadius: 20,
              animate: true,
              animationDuration: 200,
              activeBgColors: [
                [AppColors.primary, AppColors.secondary, AppColors.tertiary],
                [AppColors.primary, AppColors.secondary, AppColors.tertiary],
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: AppColors.surface,
              inactiveFgColor: AppColors.textPrimary,

              borderWidth: 5.0,
              borderColor: [AppColors.surface],
              initialLabelIndex: selectedIndex,
              totalSwitches: 2,
              labels: ['Income', 'Expense'],
              customTextStyles: [
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ],
              radiusStyle: true,
              onToggle: (index) {
                log('switched to: $index');
                if (index != null) {
                  setState(() {
                    selectedIndex = index;
                  });
                }
              },
            ),
          ),

          // const SizedBox(height: 15),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: _onToggle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
