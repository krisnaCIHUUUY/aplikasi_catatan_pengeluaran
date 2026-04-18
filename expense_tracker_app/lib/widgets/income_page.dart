import 'package:expense_tracker_app/cubit/expense_cubit.dart';
import 'package:expense_tracker_app/cubit/expense_state.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/utils/loading_state.dart';
import 'package:expense_tracker_app/widgets/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key, this.textTheme});

  final TextTheme? textTheme;

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  late DateTime selectedMonth;

  final Map<String, List<Expense>> _monthCache = {};

  String get _cacheKey =>
      '${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now();
    _loadMonthData();
  }

  void _loadMonthData() {
    if (_monthCache.containsKey(_cacheKey)) return;

    context.read<ExpenseCubit>().getExpenseByMonth(
      year: selectedMonth.year,
      month: selectedMonth.month,
    );
  }

  void _changeMonth(int monthOffset) {
    setState(() {
      selectedMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + monthOffset,
      );
    });
    _loadMonthData();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 15),
      child: BlocListener<ExpenseCubit, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseLoaded) {
            setState(() {
              _monthCache[_cacheKey] = state.expenses;
            });
          }

          if (state is ExpenseEmpty) {
            _monthCache[_cacheKey] = [];
          }
        },
        child: BlocBuilder<ExpenseCubit, ExpenseState>(
          builder: (context, state) {
            final cachedExpenses = _monthCache[_cacheKey];

            // Tampilkan loading hanya jika belum ada cache untuk bulan ini
            if (state is ExpenseLoading && cachedExpenses == null) {
              return const LoadingState();
            }

            if (state is ExpenseError && cachedExpenses == null) {
              return _buildErrorState(context, state.message);
            }

            // Gunakan data dari cache jika tersedia
            final expenses = cachedExpenses ?? [];
            final categoryTotals = _calculateCategoryTotal(expenses);
            final monthTotal = expenses.fold<double>(
              0.0,
              (sum, e) => sum + e.amount,
            );

            final isLoading = state is ExpenseLoading && cachedExpenses == null;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDateHeader(
                  textTheme,
                  monthTotal,
                  categoryTotals,
                  isLoading,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  child: Text(
                    'Pengeluaran Bulan ${DateFormat.yMMMM('id_ID').format(selectedMonth)}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (expenses.isEmpty)
                  _buildEmptyMonthState(context)
                else
                  _buildSummary(textTheme, monthTotal, expenses),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummary(
    TextTheme textTheme,
    double monthTotal,
    List<Expense> expenses,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Transaksi',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${expenses.length}',
                  style: textTheme.displayMedium?.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jumlah Pengeluaran',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  currencyFormat.format(monthTotal),
                  style: textTheme.displayMedium?.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Map<String, double> _calculateCategoryTotal(List<Expense> expenses) {
    final Map<String, double> totals = {};
    for (final expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0.0) + expense.amount;
    }
    return totals;
  }

  Widget _buildDateHeader(
    TextTheme textTheme,
    double monthTotal,
    Map<String, double> categoryTotals,
    bool isLoading,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final now = DateTime.now();
    final isCurrentMonth =
        selectedMonth.year == now.year && selectedMonth.month == now.month;

    final startDate = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final endDate = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final dateRange =
        '${DateFormat('dd MMM yyyy', 'id_ID').format(startDate)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(endDate)}';

    return Container(
      height: 510,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: isLoading ? null : () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                  color: AppColors.primary,
                ),
                Text(
                  DateFormat('MMMM yyyy', 'id_ID').format(selectedMonth),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: isCurrentMonth || isLoading
                      ? null
                      : () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          Text(dateRange, style: textTheme.titleMedium),
          const SizedBox(height: 15),
          if (isLoading)
            const SizedBox(
              height: 380,
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currencyFormat.format(monthTotal),
                  style: textTheme.displayLarge,
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 350,
                  child: MainBarChart(categoryTotals: categoryTotals),
                ),
              ],
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
              _monthCache.remove(_cacheKey);
              _loadMonthData();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMonthState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: AppColors.divider,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pengeluaran',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bulan ${DateFormat('MMMM yyyy', 'id_ID').format(selectedMonth)}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
