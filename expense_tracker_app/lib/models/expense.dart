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

  
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate()
          : DateTime.parse(json['date'] as String),
      description: json['description'],
      
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
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

  
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
