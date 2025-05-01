import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaselearning/ExpenseTrackerApp/services/AuthControllerEt.dart';
import 'package:flutter/material.dart';

class CRED {

  FirebaseFirestore dbstore = FirebaseFirestore.instance;
  final auth = AuthControllerEt();


  Future<void> uploadExpense({required String amount,required String description,required String userid,required BuildContext context,required TextEditingController itemController,required TextEditingController amountController, required DateTime date,}) async {
    await dbstore.collection("expenses").doc().set(
      {
        "date": date,
        "amount": amount,
        "description": description,
        "userId": userid,
        "createdAt": FieldValue.serverTimestamp(),
      }
    ).then((_) {
      Navigator.pop(context);
      itemController.clear();
      amountController.clear();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    });
  }
 Stream<QuerySnapshot> getExpensesStream() {
  final userId = auth.currentUser?.uid; 
  if (userId == null || userId.isEmpty) {
    return Stream.error('User not logged in'); 
  }
  
  return FirebaseFirestore.instance
      .collection("expenses")
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots();
}}