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
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    currentDate = DateTime.now();
  }

  @override
  void dispose() {
    _isMounted = false;
    itemController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
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
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            
            double totalExpenses = 0;
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              for (var doc in snapshot.data!.docs) {
                final amount = _parseAmount(doc['amount']);
                totalExpenses += amount;
              }
            }

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    color: Colors.pink[50],
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Expenses:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[800],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              currencyFormat.format(totalExpenses),
                              key: ValueKey(totalExpenses),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: snapshot.hasData && snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final amount = _parseAmount(data['amount']);
                          
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 4.h),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: ListTile(
                                title: Text(
                                  data['description'] ?? 'No title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),
                                subtitle: Text(
                                  data['date'] != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format((data['date'] as Timestamp).toDate())
                                      : 'No date',
                                  style: TextStyle(color: Colors.pink),
                                ),
                                trailing: Text(
                                  currencyFormat.format(amount),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No expenses yet',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  double _parseAmount(dynamic amount) {
    if (amount == null) return 0;
    if (amount is num) return amount.toDouble();
    if (amount is String) return double.tryParse(amount) ?? 0;
    return 0;
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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

  Future<void> _handleAddExpense(BuildContext context) async {
    if (!_isMounted) return;

    if (itemController.text.trim().isEmpty) {
      _showSnackBar("Please enter a title");
      return;
    }

    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      _showSnackBar("Please enter a valid amount");
      return;
    }

    Navigator.of(context).pop(); // Close the dialog

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await dbstore.uploadExpense(
        amount: amount, 
        description: itemController.text,
        userId: authController.currentUser?.uid ?? '',
        date: currentDate,
      );

      if (!_isMounted) return;
      itemController.clear();
      amountController.clear();
    } catch (e) {
      if (!_isMounted) return;
      _showSnackBar("Error: ${e.toString()}");
    } finally {
      if (_isMounted) {
        Navigator.of(context).pop(); // Close loading indicator
      }
    }
  }

  void _showSnackBar(String message) {
    if (!_isMounted) return;
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}