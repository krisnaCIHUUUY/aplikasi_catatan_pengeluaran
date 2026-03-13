import 'package:flutter/material.dart';

class ExpenseIconCard extends StatelessWidget {
  final IconData icon;
  final Color color;

  const ExpenseIconCard({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.3),
      ),
      child: Icon(icon, color: color),
    );
  }
}
