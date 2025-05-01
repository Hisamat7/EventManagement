import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaselearning/ExpenseTrackerApp/services/AuthControllerEt.dart';
import 'package:firebaselearning/ExpenseTrackerApp/services/CRED.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomeScreenEt extends StatefulWidget {
  const HomeScreenEt({super.key});

  @override
  State<HomeScreenEt> createState() => _HomeScreenEtState();
}

class _HomeScreenEtState extends State<HomeScreenEt> {
  final AuthControllerEt authController = AuthControllerEt();
  final TextEditingController itemController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final dbstore = CRED();
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
  }

  @override
  void dispose() {
    itemController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15),
        child: FloatingActionButton(
          elevation: 7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            setState(() {
              currentDate = DateTime.now();
            });
            _showAddExpenseDialog(context);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.pink[400],
        title: const Text(
          "Expense Tracker", 
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await authController.logout(context: context);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dbstore.getExpensesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No expenses found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  child: ListTile(
                  title: Text(data['description'] ?? 'No title', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.pink),),
                  subtitle:Text(
                    style: const TextStyle(color: Colors.pink),
                    data['date'] != null 
                    ? DateFormat('dd/MM/yyyy').format((data['date'] as Timestamp).toDate())
                    : 'No date'),
                  trailing:
                   Text('\$${data['amount'] ?? '0'}', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.pink),),
                   
                ),
                color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                
                  )),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        elevation: 10,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: const Text(
          "Add New Expense",
          style: TextStyle(color: Colors.pinkAccent),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Date: ${DateFormat('dd/MM/yyyy').format(currentDate)}",
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: itemController,
                style: const TextStyle(color: Colors.pinkAccent),
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: const TextStyle(color: Colors.pinkAccent),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Colors.pink),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 190, 75, 113)),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.pinkAccent),
                decoration: InputDecoration(
                  labelText: "Amount",
                  labelStyle: const TextStyle(color: Colors.pinkAccent),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Colors.pink),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 200, 94, 130)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              itemController.clear();
              amountController.clear();
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.pinkAccent),
            ),
          ),
          TextButton(
            onPressed: () => _handleAddExpense(context),
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddExpense(BuildContext context) {
    if (itemController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a title")),
      );
      return;
    }

    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }

    dbstore.uploadExpense(
      amount: amount.toString(),
      description: itemController.text,
      userid: authController.currentUser?.uid ?? '',
      date: currentDate,
      context: context,
      itemController: itemController,
      amountController: amountController,
    ).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }
}