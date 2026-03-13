import 'package:expense_tracker_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/utils/expense_icon.dart';
import 'package:expense_tracker_app/widgets/expense_card.dart';
import 'package:expense_tracker_app/widgets/summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // APP BAR
          Container(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 15,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.4),
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Selamat Pagi,", style: textTheme.bodyMedium),
                          Text(
                            "Budi Santoso",
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // summary card
          SummaryCard(saldo: 0, pengeluaran: 0, pemasukan: 0),

          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transaksi",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Lihat Semua",
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          // tanggal dan list tarnsaksi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              "HARI INI, 12 MEI",
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
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
    );
  }
}
