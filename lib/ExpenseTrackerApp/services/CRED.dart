import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaselearning/ExpenseTrackerApp/services/AuthControllerEt.dart';

class CRED {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthControllerEt _authController = AuthControllerEt();

  Future<void> uploadExpense({
    required double amount,
    required String description,
    required String userId,
    required DateTime date,
  }) async {
    try {
      await _firestore.collection('expenses').add({
        'amount': amount,
        'description': description,
        'userId': userId,
        'date': Timestamp.fromDate(date),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to upload expense: $e');
    }
  }

  Stream<QuerySnapshot> getExpensesStream() {
    final userId = _authController.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      return Stream.error('User not logged in');
    }
    
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<double> getTotalExpenses(String userId) async {
    try {
      final snapshot = await _firestore.collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();
      
      double total = 0;
      for (var doc in snapshot.docs) {
        final amount = doc['amount'];
        if (amount is num) {
          total += amount.toDouble();
        } else if (amount is String) {
          total += double.tryParse(amount) ?? 0;
        }
      }
      return total;
    } catch (e) {
      throw Exception('Failed to get total expenses: $e');
    }
  }
}