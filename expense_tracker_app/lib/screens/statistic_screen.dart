import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/utils/expense_icon.dart';
import 'package:expense_tracker_app/widgets/bar_chart.dart';
import 'package:expense_tracker_app/widgets/expense_card.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // appbar
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

            // const SizedBox(height: 15),
            // togle
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
                initialLabelIndex: 1,
                totalSwitches: 2,
                labels: ['Income', 'Expense'],
                customTextStyles: [
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ],
                radiusStyle: true,
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
            ),

            const SizedBox(height: 20),

            Container(
              height: 510,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.only(top: 18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '01 Jan 2021 - 01 Maret 2021',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 15),
                  Text('\$3500.00', style: textTheme.displayLarge),
                  const SizedBox(height: 15),
                  MainBarChart(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hari ini, 12 Mei 2021",
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("-\$5000", style: textTheme.bodyMedium),
                ],
              ),
            ),

            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                children: [
                  // transaksi item
                  ExpenseCard(
                    title: "Nasi Goreng Spesial",
                    time: "12:30 PM",
                    amount: 12000,
                    icon: ExpenseIcon.makanan,
                    color: AppColors.makanan,
                  ),
                  ExpenseCard(
                    title: "Ojek Online",
                    time: "12:30 PM",
                    amount: 25000,
                    icon: ExpenseIcon.transport,
                    color: AppColors.transport,
                  ),
                  ExpenseCard(
                    title: "Minimarket",
                    time: "12:30 PM",
                    amount: 20000,
                    icon: ExpenseIcon.belanja,
                    color: AppColors.belanja,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
