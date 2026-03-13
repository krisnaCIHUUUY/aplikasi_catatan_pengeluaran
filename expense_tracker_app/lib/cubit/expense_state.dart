import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/expense_category.dart';

abstract class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

// loadoing
class Expenseloading extends ExpenseState {}

// success
class Expenseloaded extends ExpenseState {
  final List<Expense>? expenses;
  final double? totalAmount;
  final List<ExpenseCategory>? categories;

  Expenseloaded({this.expenses, this.totalAmount, this.categories});
}

// error
class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}

class ExpenseNotFound extends ExpenseState {
  final String? message;

  ExpenseNotFound({this.message});
}

// empty
class ExpenseEmpty extends ExpenseState {}
