import 'package:expense_tracker_app/utils/colors.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double saldo;
  final double pengeluaran;
  final double pemasukan;
  const SummaryCard({
    super.key,
    required this.saldo,
    required this.pengeluaran,
    required this.pemasukan,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final percentage = saldo > 0 ? (pengeluaran / saldo) * 100 : 0.0;

    final remaining = saldo - pengeluaran;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          // color: AppColors.primary,
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.tertiary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Saldo",
                  style: textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                SizedBox(width: 10),
                // Icon(Icons.money_rounded, color: Colors.white),
              ],
            ),

            SizedBox(height: 20),
            Text(
              "Rp ${saldo.toStringAsFixed(0)}",
              style: textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.background.withValues(alpha: 0.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.arrow_outward, color: Colors.white),
                            Text(
                              "Pengeluaran",
                              style: textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Rp ${pengeluaran.toStringAsFixed(0)}",
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.background.withValues(alpha: 0.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.arrow_downward, color: Colors.white),
                            Text(
                              "Pemasukan",
                              style: textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Rp ${pemasukan.toStringAsFixed(0)}",
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
