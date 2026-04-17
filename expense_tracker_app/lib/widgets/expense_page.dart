import 'package:expense_tracker_app/cubit/expense_cubit.dart';
import 'package:expense_tracker_app/cubit/expense_state.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/expense_category.dart';
import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/utils/empty_state.dart';
import 'package:expense_tracker_app/utils/expense_icon.dart';
import 'package:expense_tracker_app/utils/loading_state.dart';
import 'package:expense_tracker_app/widgets/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseCubit>().loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return LoadingState();
          }

          if (state is ExpenseError) {
            return _buildErrorState(context, state.message);
          }

          if (state is ExpenseEmpty) {
            return EmptyState();
          }

          if (state is ExpenseLoaded) {
            final expenses = state.expenses;

            if (expenses.isEmpty) {
              return EmptyState();
            }

            // mengelompokkan data berdasarkan tannggal
            final groupedExpenses = _groupExpensesByDate(expenses);

            // kalkulasi total
            final totalAmount = expenses.fold<double>(
              0.0,
              (sum, expense) => sum + expense.amount,
            );

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: groupedExpenses.length + 1, // +1 untuk header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildHeader(textTheme, totalAmount, expenses.length);
                }

                //Date section
                final dateKey = groupedExpenses.keys.elementAt(index - 1);
                final expensesForDate = groupedExpenses[dateKey]!;
                final dailyTotal = expensesForDate.fold<double>(
                  0.0,
                  (sum, expense) => sum + expense.amount,
                );

                return _buildDateSection(
                  dateKey,
                  expensesForDate,
                  dailyTotal,
                  textTheme,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Mengelompokkan expenses berdasarkan tanggal
  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};

    for (var expense in expenses) {
      // Format tanggal untuk key nya
      final dateKey = DateFormat('dd MMM yyyy', 'id_ID').format(expense.date);

      // Jika key belum ada, buat list baru
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }

      // Tambahkan expense ke list
      grouped[dateKey]!.add(expense);
    }

    // sort tanggal yang terbaru
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('dd MMM yyyy', 'id_ID').parse(a);
        final dateB = DateFormat('dd MMM yyyy', 'id_ID').parse(b);
        return dateB.compareTo(dateA); // Descending (terbaru dulu)
      });

    // Return map yang sudah sorted
    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  Widget _buildHeader(TextTheme textTheme, double total, int count) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary, AppColors.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Pengeluaran',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(total),
            style: textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: Colors.white.withValues(alpha: 0.8),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '$count Transaksi',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(
    String dateKey,
    List<Expense> expenses,
    double dailyTotal,
    TextTheme textTheme,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header dengan total harian
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tanggal dengan label "Hari ini" jika hari ini
              Row(
                children: [
                  Text(
                    _formatDateHeader(dateKey),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  // pengkondisian untuk jika date adalah  hari ini
                  if (_isToday(dateKey)) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Hari ini',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              // Total harian
              Text(
                '-${currencyFormat.format(dailyTotal)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        //List expenses untuk tanggal ini
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: expenses.asMap().entries.map((entry) {
              final expense = entry.value;
              final isLast = entry.key == expenses.length - 1;

              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                child: ExpenseCard(
                  title: expense.title,
                  time: DateFormat('HH:mm').format(expense.date),
                  amount: expense.amount,
                  icon: _getCategoryIcon(
                    ExpenseCategory.fromString(expense.category),
                  ),
                  color: AppColors.getCategoryColor(expense.category),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Format header tanggal dengan label hari
  String _formatDateHeader(String dateKey) {
    final date = DateFormat('dd MMM yyyy', 'id_ID').parse(dateKey);
    final now = DateTime.now();

    // Check jika hari ini
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return dateKey;
    }

    // Check jika kemarin
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Kemarin, $dateKey';
    }

    // Tambahkan nama hari
    final dayName = DateFormat('EEEE', 'id_ID').format(date);
    return '$dayName, $dateKey';
  }

  bool _isToday(String dateKey) {
    final date = DateFormat('dd MMM yyyy', 'id_ID').parse(dateKey);
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.makanan:
        return ExpenseIcon.makanan;
      case ExpenseCategory.transportasi:
        return ExpenseIcon.transport;
      case ExpenseCategory.belanja:
        return ExpenseIcon.belanja;
      case ExpenseCategory.hiburan:
        return ExpenseIcon.hiburan;
      case ExpenseCategory.kesehatan:
        return ExpenseIcon.kesehatan;
      case ExpenseCategory.lainnya:
        return ExpenseIcon.lainnya;
    }
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Terjadi Kesalahan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ExpenseCubit>().loadExpenses();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
