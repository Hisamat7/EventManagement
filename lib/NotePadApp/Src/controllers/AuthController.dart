import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselearning/NotePadApp/Src/Views/HomeScreenPage.dart';
import 'package:firebaselearning/NotePadApp/Src/Views/LoginScreenPage.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> register({
    required String email,
    required String password,
    required BuildContext context, // Need context for navigation
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreenPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An unexpected error occurred')));
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreenPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled';
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password';
      } else {
        errorMessage = e.message ?? 'Login failed';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Platform error occurred. Try again later.')),
      );
      debugPrint('Platform error: $e');
    }
  }
  Future<void> logout({required BuildContext context}) async {
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreenPage()));
  }
}
