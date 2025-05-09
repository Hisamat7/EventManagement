import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebaselearning/TodoApp/src/views/HomeTodo.dart';
import 'package:firebaselearning/TodoApp/src/views/LoginTodo.dart';

class SplashTodo extends StatefulWidget {
  const SplashTodo({super.key});

  @override
  State<SplashTodo> createState() => _SplashTodoState();
}

class _SplashTodoState extends State<SplashTodo> {
  static const _splashDelay = Duration(seconds: 3);
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(_splashDelay);
    
    try {
      final currentUser = _auth.currentUser;
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => currentUser != null ? HomeTodo() : LoginTodo(),
          ),
        );
      }
    } catch (e) {
 
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginTodo()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Todo App", 
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.orangeAccent),
          ],
        ),
      ),
    );
  }
}