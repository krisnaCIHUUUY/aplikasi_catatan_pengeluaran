import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/utils/expense_icon.dart';
import 'package:expense_tracker_app/widgets/bar_chart.dart';
import 'package:expense_tracker_app/widgets/expense_card.dart';
import 'package:flutter/material.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key, this.textTheme});

  final TextTheme? textTheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(top: 15),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
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
                SizedBox(height: 350, child: MainBarChart()),
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

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Column(
              // shrinkWrap: true,
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
    );
  }
}
