import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaselearning/ExpenseTrackerApp/views/HomeScreenEt.dart';
import 'package:firebaselearning/ExpenseTrackerApp/views/SignInEt.dart';
import 'package:firebaselearning/ExpenseTrackerApp/views/SignUpEt.dart';
import 'package:flutter/material.dart';

class ExpenseTrackerSplashScreen extends StatefulWidget {
  const ExpenseTrackerSplashScreen({super.key});

  @override
  State<ExpenseTrackerSplashScreen> createState() =>
      _ExpenseTrackerSplashScreenState();
}

class _ExpenseTrackerSplashScreenState extends State<ExpenseTrackerSplashScreen> {
final  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (_auth.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreenEt()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInEt()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Expense Tracker",
          style: TextStyle(
            color: const Color.fromARGB(255, 247, 49, 118),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
