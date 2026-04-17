import 'dart:developer';

import 'package:expense_tracker_app/cubit/expense_state.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/expense_category.dart';
import 'package:expense_tracker_app/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseInitial());

  Future<void> loadExpenses() async {
    try {
      emit(ExpenseLoading());

      final expenses = await FirebaseService.fetchData();

      if (expenses.isEmpty) {
        emit(ExpenseEmpty());
      } else {
        final double total = expenses.fold<double>(
          0.0,
          (sum, expense) => sum + expense.amount,
        );
        emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
      }
    } catch (e, stackTrace) {
      log('ExpenseCubit: Error loading expenses: $e\n$stackTrace');
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      emit(ExpenseLoading());
      await FirebaseService.createData(expense);
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError('Gagal menambahkan data: ${e.toString()}'));
    }
  }

  Future<void> updateExpense(String id, Expense expense) async {
    try {
      emit(ExpenseLoading());
      await FirebaseService.updateData(id, expense);
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError('Gagal mengupdate data: ${e.toString()}'));
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      emit(ExpenseLoading());
      await FirebaseService.deleteData(id);
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError('Gagal menghapus data: ${e.toString()}'));
    }
  }

  Future<void> getExpensesByCategory(ExpenseCategory category) async {
    try {
      emit(ExpenseLoading());
      final expenses = await FirebaseService.getExpenseByCategory(category);

      if (expenses.isEmpty) {
        emit(ExpenseEmpty());
      } else {
        final double total = expenses.fold<double>(
          0.0,
          (sum, expense) => sum + expense.amount,
        );
        emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
      }
    } catch (e) {
      emit(ExpenseError('Gagal mendapatkan kategori: ${e.toString()}'));
    }
  }

  Future<void> deleteAllExpenses() async {
    try {
      emit(ExpenseLoading());
      await FirebaseService.deleteAllExpenses();
      await loadExpenses();
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> getExpenseByMonth({
    required int year,
    required int month,
  }) async {
    try {
      emit(ExpenseLoading());

      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 1);
      final expenses = await FirebaseService.getExpensesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );

      if (expenses.isEmpty) {
        emit(ExpenseEmpty());
      } else {
        final double total = expenses.fold<double>(
          0.0,
          (sum, expense) => sum + expense.amount,
        );
        emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
      }
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}
