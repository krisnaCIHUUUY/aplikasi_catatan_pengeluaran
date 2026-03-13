import 'dart:convert';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/expense_category.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.18.7:3000";

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };

  // GET all expenses
  Future<List<Expense>> getAllExpenses() async {
    try {
      final uri = Uri.parse("$baseUrl/expense");
      final res = await http.get(uri, headers: _headers);

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);

        // Cek apakah data kosong
        if (responseData['data'] == null || responseData['data'].isEmpty) {
          return [];
        }

        final List data = responseData['data'];
        return data.map((e) => Expense.fromJson(e)).toList();
      } else if (res.statusCode == 404) {
        // Jika tidak ada data, return list kosong
        return [];
      } else {
        throw Exception("Gagal mengambil data: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // GET expense by ID
  Future<Expense> getExpenseById(String id) async {
    try {
      final uri = Uri.parse("$baseUrl/expense/$id");
      final res = await http.get(uri, headers: _headers);

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        return Expense.fromJson(responseData['data']);
      } else if (res.statusCode == 404) {
        throw Exception("Expense tidak ditemukan");
      } else {
        throw Exception("Gagal mengambil data: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // GET expenses by category
  Future<List<Expense>> getExpensesByCategory(ExpenseCategory category) async {
    try {
      final uri = Uri.parse(
        "$baseUrl/expense/category/${category.displayName}",
      );
      final res = await http.get(uri, headers: _headers);

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);

        if (responseData['data'] == null || responseData['data'].isEmpty) {
          return [];
        }

        final List data = responseData['data'];
        return data.map((e) => Expense.fromJson(e)).toList();
      } else if (res.statusCode == 404) {
        return [];
      } else {
        throw Exception("Gagal mengambil data: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // GET total expenses
  Future<double> getTotalExpenses() async {
    try {
      final uri = Uri.parse("$baseUrl/expense/total");
      final res = await http.get(uri, headers: _headers);

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        return (responseData['data']['total'] ?? 0).toDouble();
      } else {
        throw Exception("Gagal mengambil total: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // CREATE expense
  Future<Expense> createExpense(Expense expense) async {
    try {
      final uri = Uri.parse("$baseUrl/expense");
      final body = jsonEncode(expense.toJson());
      final res = await http.post(uri, headers: _headers, body: body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        return Expense.fromJson(responseData['data']);
      } else {
        final errorData = jsonDecode(res.body);
        throw Exception(
          "Gagal menambah expense: ${errorData['message'] ?? res.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // UPDATE expense
  Future<Expense> updateExpense(String id, Expense expense) async {
    try {
      final uri = Uri.parse("$baseUrl/expense/$id");
      final body = jsonEncode(expense.toJson());
      final res = await http.put(uri, headers: _headers, body: body);

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        return Expense.fromJson(responseData['data']);
      } else if (res.statusCode == 404) {
        throw Exception("Expense tidak ditemukan");
      } else {
        final errorData = jsonDecode(res.body);
        throw Exception(
          "Gagal update expense: ${errorData['message'] ?? res.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // DELETE expense
  Future<void> deleteExpense(String id) async {
    try {
      final uri = Uri.parse("$baseUrl/expense/$id");
      final res = await http.delete(uri, headers: _headers);

      if (res.statusCode == 200) {
        // Berhasil dihapus
        return;
      } else if (res.statusCode == 404) {
        throw Exception("Expense tidak ditemukan");
      } else {
        final errorData = jsonDecode(res.body);
        throw Exception(
          "Gagal menghapus expense: ${errorData['message'] ?? res.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // BONUS: Get expenses by date range
  Future<List<Expense>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Ambil semua expenses dulu
      final allExpenses = await getAllExpenses();

      // Filter by date range di client side
      return allExpenses.where((expense) {
        return expense.date.isAfter(startDate.subtract(Duration(days: 1))) &&
            expense.date.isBefore(endDate.add(Duration(days: 1)));
      }).toList();
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // BONUS: Get statistics by category
  Future<Map<String, double>> getStatisticsByCategory() async {
    try {
      final expenses = await getAllExpenses();

      Map<String, double> stats = {};

      for (var expense in expenses) {
        if (stats.containsKey(expense.category)) {
          stats[expense.category] = stats[expense.category]! + expense.amount;
        } else {
          stats[expense.category] = expense.amount;
        }
      }

      return stats;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
