import 'package:expense_tracker_app/models/expense.dart';

abstract class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseLoading extends ExpenseState {}

final class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final double totalAmount;

  ExpenseLoaded({required this.expenses, required this.totalAmount});
}

final class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}

final class ExpenseEmpty extends ExpenseState {}
