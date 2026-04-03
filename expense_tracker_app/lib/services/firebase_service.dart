import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/expense_category.dart';

class FirebaseService {
  static final _firestore = FirebaseFirestore.instance;
  static const String _collectionName = "expenses";

  static CollectionReference<Map<String, dynamic>> get _collectionReference =>
      _firestore.collection(_collectionName);

  // logic seng di butohno:

  // fetchdata
  static Future<List<Expense>> fetchData() async {
    try {
      final querySnapshot = await _collectionReference
          .orderBy('date', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      // print("fetchdata:  ${querySnapshot}");
      final expenses = querySnapshot.docs.map((doc) {
        try {
          final data = doc.data();
          data['id'] = doc.id;

          print('🔄 Parsing document ${doc.id}...');
          print('🔄 Data to parse: $data');

          final expense = Expense.fromJson(data);
          return expense;
        } catch (e) {
          print('❌ Error parsing document ${doc.id}: $e');
          print('❌ Stack trace: ${StackTrace.current}');
          rethrow;
        }
      }).toList();

      return expenses;
    } catch (e) {
      throw Exception('gagal mengambil data, error: ${e.toString()}');
    }
  }

  // fetch realtime
  static Stream<List<Expense>> fetchDataStream() {
    return _collectionReference
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Expense.fromJson(data);
          }).toList();
        });
  }

  // create data
  static Future<Expense> createData(Expense expense) async {
    try {
      final Map<String, dynamic> newExpense = {
        'title': expense.title,
        'amount': expense.amount,
        'category': expense.category,
        'date': Timestamp.fromDate(expense.date),
        'description': expense.description,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _collectionReference.add(newExpense);
      final doc = await docRef.get();
      final data = doc.data()!;
      data['id'] = doc.id;
      return Expense.fromJson(data);
    } catch (e) {
      throw Exception("gagal membuat data, error: ${e.toString()}");
    }
  }

  // update data
  static Future<Expense> updateData(String id, Expense expense) async {
    try {
      final docRef = _collectionReference.doc(id);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception("document tidak id ${id.toString()} ditemukan");
      }

      final Map<String, dynamic> updatedExpense = {
        'title': expense.title,
        'amount': expense.amount,
        'category': expense.category,
        'date': Timestamp.fromDate(expense.date),
        'description': expense.description,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await docRef.update(updatedExpense);

      final updatedDoc = await docRef.get();
      final data = updatedDoc.data()!;
      data['id'] = updatedDoc.id;

      return Expense.fromJson(data);
    } catch (e) {
      throw Exception('gagal mengupdate data, error: ${e.toString()}');
    }
  }

  // delete
  static Future<void> deleteData(String id) async {
    try {
      final docRef = _collectionReference.doc(id);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception("expense dengan id ${id.toString()}, tidak di temukan");
      }

      return docRef.delete();
    } catch (e) {
      throw Exception("gagal menghapus data, error: ${e.toString()}");
    }
  }

  // get by id
  static Future<Expense> getExpenseById(String id) async {
    try {
      final docSnapshot = await _collectionReference.doc(id).get();
      if (!docSnapshot.exists) {
        throw Exception("data dengan id ${id.toString()}, tidak ditemukan");
      }

      final data = docSnapshot.data()!;
      data['id'] = docSnapshot.id;

      return Expense.fromJson(data);
    } catch (e) {
      throw Exception(
        "gagal mengambil data dengan id: ${id.toString()}, error: ${e.toString()}",
      );
    }
  }

  // get by kategori
  static Future<List<Expense>> getExpenseByCategory(
    ExpenseCategory category,
  ) async {
    try {
      final querySnapshot = await _collectionReference
          .where("category", isEqualTo: category.displayName)
          .orderBy("date", descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        return Expense.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception(
        "gagal mengambil data berdasarkan kategori, error: ${e.toString()}",
      );
    }
  }

  static Future<List<Expense>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final querySnapshot = await _collectionReference
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Expense.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data range: $e');
    }
  }

  static Future<double> getTotalExpenses() async {
    try {
      final querySnapshot = await _collectionReference.get();

      if (querySnapshot.docs.isEmpty) {
        return 0;
      }

      double total = 0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        total += (data['amount'] as num).toDouble();
      }

      return total;
    } catch (e) {
      throw Exception('Gagal menghitung total: $e');
    }
  }

  static Future<Map<String, double>> getTotalByCategory() async {
    try {
      final querySnapshot = await _collectionReference.get();

      if (querySnapshot.docs.isEmpty) {
        return {};
      }

      Map<String, double> categoryTotals = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final category = data['category'] as String;
        final amount = (data['amount'] as num).toDouble();

        if (categoryTotals.containsKey(category)) {
          categoryTotals[category] = categoryTotals[category]! + amount;
        } else {
          categoryTotals[category] = amount;
        }
      }

      return categoryTotals;
    } catch (e) {
      throw Exception('Gagal menghitung total kategori: $e');
    }
  }

  static Future<void> deleteAllExpenses() async {
    try {
      final querySnapshot = await _collectionReference.get();

      final batch = _firestore.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Gagal menghapus semua data: $e');
    }
  }
}
