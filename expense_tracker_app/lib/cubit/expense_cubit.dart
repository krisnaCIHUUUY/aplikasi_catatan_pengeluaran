import 'package:expense_tracker_app/cubit/expense_state.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/expense_category.dart';
import 'package:expense_tracker_app/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseInitial());

  Future<void> loadExpenses() async {
    try {
      emit(Expenseloading());

      final expenses = await FirebaseService.fetchData();
      
      if (expenses.isEmpty) {
        print('ExpenseCubit: No expenses, emitting ExpenseEmpty');
        emit(ExpenseEmpty());
      } else {
        final double total = expenses.fold<double>(
          0.0,
          (sum, expense) => sum + expense.amount,
        );
        emit(Expenseloaded(expenses: expenses, totalAmount: total));
      }
    } catch (e, stackTrace) {
      print('ExpenseCubit: Error loading expenses: $e');
      print('Stack trace: $stackTrace');
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> loadExpensesById(String id) async {
    try {
      emit(Expenseloading());
      final expense = await FirebaseService.getExpenseById(id);
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
      await FirebaseService.createData(expense);
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError("gagal menambahkan data: ${e.toString()}"));
    }
  }

  Future<void> updateExpense(String id, Expense expense) async {
    try {
      emit(Expenseloading());
      await FirebaseService.updateData(id, expense);
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError("gagal mengupdate data: ${e.toString()}"));
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      emit(Expenseloading());
      await FirebaseService.deleteData(id);
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError("gagal menghapus data: ${e.toString()}"));
    }
  }

  // get total

  Future<void> getTotalExpense() async {
    try {
      emit(Expenseloading());
      final double total = await FirebaseService.getTotalExpenses();
      emit(Expenseloaded(totalAmount: total));
    } catch (e) {
      emit(ExpenseError("gagal mendapatkan total: ${e.toString()}"));
    }
  }

  // get category
  Future<void> getExpensesByCategory(ExpenseCategory category) async {
    try {
      emit(Expenseloading());
      final List<Expense> categories =
          await FirebaseService.getExpenseByCategory(category);

      if (categories.isNotEmpty) {
        emit(Expenseloaded(expenses: categories));
      } else {
        emit(ExpenseEmpty());
      }
    } catch (e) {
      emit(ExpenseError("gagal mendapatkan kategori: ${e.toString()}"));
    }
  }

  Future<void> deleteAllExpenses() async {
    try {
      emit(Expenseloading());
      await FirebaseService.deleteAllExpenses();
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}
