import 'package:expense_tracker_app/cubit/expense_cubit.dart';
import 'package:expense_tracker_app/cubit/expense_state.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/expense_category.dart';
import 'package:expense_tracker_app/routes/app_router.dart';
import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/utils/empty_state.dart';
import 'package:expense_tracker_app/utils/loading_state.dart';
import 'package:expense_tracker_app/widgets/date_header.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/utils/expense_icon.dart';
import 'package:expense_tracker_app/widgets/expense_card.dart';
import 'package:expense_tracker_app/widgets/summary_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseCubit>().loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          List<Expense> allExpenses = [];
          List<Expense> todayExpenses = [];
          double totalExpenses = 0.0;

          if (state is ExpenseLoaded) {
            allExpenses = state.expenses;
            totalExpenses = state.totalAmount;

            // Filter today's expenses
            final today = DateTime.now();
            todayExpenses = allExpenses.where((expense) {
              return expense.date.year == today.year &&
                  expense.date.month == today.month &&
                  expense.date.day == today.day;
            }).toList();
          }

          return CustomScrollView(
            slivers: [
              // 1. Header (Profile & Settings)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.4,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                "Budi Santoso",
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => context.go(AppRoutes.setting),
                        icon: const Icon(Icons.settings),
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Summary Card
              SliverToBoxAdapter(
                child: SummaryCard(
                  saldo: 2500000.0,
                  pengeluaran: totalExpenses,
                  pemasukan: 0.0,
                ),
              ),

              // 3. Transaction Header
              SliverToBoxAdapter(
                child: _buildTransactionHeader(textTheme, DateTime.now()),
              ),

              // 4. Content based on state
              if (state is ExpenseLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: LoadingState(),
                )
              else if (state is ExpenseError)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildErrorState(context, state.message),
                )
              else if (state is ExpenseEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(),
                )
              else if (todayExpenses.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildNoTodayExpenses(context),
                )
              else if (state is ExpenseLoaded)
                _buildExpenseList(todayExpenses),

              // Bottom spacing for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExpenseList(List<Expense> todayExpenses) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final expense = todayExpenses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
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
        }, childCount: todayExpenses.length),
      ),
    );
  }

  Widget _buildTransactionHeader(TextTheme textTheme, DateTime date) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transaksi",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.go(AppRoutes.transaction);
                },
                child: Text(
                  "Lihat Semua",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          DateHeader(textTheme: textTheme, date: date),
        ],
      ),
    );
  }

  Widget _buildNoTodayExpenses(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 120, color: AppColors.divider),
          const SizedBox(height: 24),
          Text(
            'Belum ada transaksi hari ini',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Transaksi yang Anda buat hari ini\nakan muncul di sini',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi,';
    } else if (hour < 15) {
      return 'Selamat Siang,';
    } else if (hour < 18) {
      return 'Selamat Sore,';
    } else {
      return 'Selamat Malam,';
    }
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
}
