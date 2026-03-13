import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/widgets/expense_icon_card.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final String title;
  final String time;
  final double amount;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.time,
    required this.amount,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: AppColors.surface,
        leading: ExpenseIconCard(icon: icon, color: color),
        title: Text(
          title,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(time, style: textTheme.bodySmall),
        trailing: Text(
          "- Rp ${amount.toStringAsFixed(0)}",
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
