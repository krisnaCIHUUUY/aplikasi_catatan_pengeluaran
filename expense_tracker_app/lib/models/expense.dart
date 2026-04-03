// lib/models/expense.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ FROM FIRESTORE dengan DEBUGGING
  factory Expense.fromJson(Map<String, dynamic> json) {
    try {
      print('🔄 Parsing JSON: $json');

      final id = json['id'] as String? ?? '';
      print('ID: $id');

      final title = json['title'] as String? ?? '';
      print('Title: $title');

      final amount = _parseAmount(json['amount']);
      print('Amount: $amount');

      final category = json['category'] as String? ?? '';
      print('Category: $category');

      final date = _parseDate(json['date']);
      print('Date: $date');

      final description = json['description'] as String?;
      print('Description: $description');

      final createdAt = _parseDate(json['createdAt']) ?? DateTime.now();
      print('CreatedAt: $createdAt');

      final updatedAt = _parseDate(json['updatedAt']) ?? DateTime.now();
      print(' UpdatedAt: $updatedAt');

      return Expense(
        id: id,
        title: title,
        amount: amount,
        category: category,
        date: date ?? DateTime.now(),
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e, stackTrace) {
      print('Error in fromJson: $e');
      print('JSON data: $json');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static double _parseAmount(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    // Firestore Timestamp
    if (value is Timestamp) {
      return value.toDate();
    }

    // String date
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('⚠️ Failed to parse date string: $value');
        return null;
      }
    }

    // DateTime object
    if (value is DateTime) {
      return value;
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, category: $category, date: $date)';
  }
}
