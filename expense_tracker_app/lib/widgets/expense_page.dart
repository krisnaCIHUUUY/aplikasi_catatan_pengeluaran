import 'dart:developer';

import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/utils/expense_icon.dart';
import 'package:expense_tracker_app/widgets/expense_card.dart';
import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ListView(
        children: [
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
              children: _expenseWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _expenseWidgets() => List.generate(10, (index) {
    log(index.toString());
    return ExpenseCard(
      title: "Nasi Goreng Spesial",
      time: "12:30 PM",
      amount: 12000,
      icon: ExpenseIcon.makanan,
      color: AppColors.makanan,
    );
  });
}
