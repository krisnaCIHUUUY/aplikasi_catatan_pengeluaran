import 'package:expense_tracker_app/cubit/expense_state.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/expense_category.dart';
import 'package:expense_tracker_app/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ApiService apiService;
  ExpenseCubit(this.apiService) : super(ExpenseInitial());

  Future<void> loadExpenses() async {
    try {
      emit(Expenseloading());

      final expenses = await apiService.getAllExpenses();

      if (expenses.isEmpty) {
        emit(ExpenseEmpty());
      } else {
        final double total = expenses.fold(
          0,
          (sum, expense) => sum + expense.amount,
        );
        emit(Expenseloaded(expenses: expenses, totalAmount: total));
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> loadExpensesById(String id) async {
    try {
      emit(Expenseloading());
      final expense = await apiService.getExpenseById(id);
      if (expense.id.isEmpty) {
        emit(ExpenseNotFound());
      } else {
        emit(Expenseloaded(expenses: [expense], totalAmount: expense.amount));
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      emit(Expenseloading());
      await apiService.createExpense(expense);
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError("gagal menambahkan data: ${e.toString()}"));
    }
  }

  Future<void> updateExpense(String id, Expense expense) async {
    try {
      emit(Expenseloading());
      await apiService.updateExpense(id, expense);
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError("gagal mengupdate data: ${e.toString()}"));
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      emit(Expenseloading());
      await apiService.deleteExpense(id);
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError("gagal menghapus data: ${e.toString()}"));
    }
  }

  // get total

  Future<void> getTotalExpense() async {
    try {
      emit(Expenseloading());
      final double total = apiService.getTotalExpenses() as double;
      emit(Expenseloaded(totalAmount: total));
    } catch (e) {
      emit(ExpenseError("gagal mendapatkan total: ${e.toString()}"));
    }
  }

  // get category
  Future<void> getExpensesByCategory(ExpenseCategory category) async {
    try {
      emit(Expenseloading());
      final List<Expense> categories = await apiService.getExpensesByCategory(
        category,
      );

      if (categories.isNotEmpty) {
        emit(Expenseloaded(expenses: categories));
      }
    } catch (e) {
      emit(ExpenseError("gagal mendapatkan kategori: ${e.toString()}"));
    }
  }
}
