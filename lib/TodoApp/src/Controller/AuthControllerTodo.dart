import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebaselearning/TodoApp/src/views/HomeTodo.dart';
import 'package:firebaselearning/TodoApp/src/views/LoginTodo.dart';

class AuthControllerTodo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<void> register({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeTodo()),
          (route) => false, // Remove all previous routes
        );
      }
    } on FirebaseAuthException catch (e) {
      _showAuthError(context, e);
    } catch (e) {
      _showGenericError(context);
      debugPrint('Registration error: $e');
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeTodo()),
          (route) => false, // Clear navigation stack
        );
      }
    } on FirebaseAuthException catch (e) {
      _showAuthError(context, e);
    } catch (e) {
      _showGenericError(context);
      debugPrint('Login error: $e');
    }
  }

  Future<void> logout({required BuildContext context}) async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginTodo()),
        (route) => false, // Remove all routes
      );
    } catch (e) {
      _showGenericError(context);
      debugPrint('Logout error: $e');
    }
  }

  void _showAuthError(BuildContext context, FirebaseAuthException e) {
    String errorMessage;

    switch (e.code) {
      case 'invalid-email':
        errorMessage = 'Invalid email format';
        break;
      case 'user-disabled':
        errorMessage = 'This account has been disabled';
        break;
      case 'user-not-found':
        errorMessage = 'No user found with this email';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password';
        break;
      case 'email-already-in-use':
        errorMessage = 'Email is already registered';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Email/password sign-in is disabled';
        break;
      case 'weak-password':
        errorMessage = 'Password must be at least 6 characters';
        break;
      case 'network-request-failed':
        errorMessage = 'Network error. Check your connection.';
        break;
      default:
        errorMessage = e.message ?? 'Authentication failed';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void _showGenericError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An unexpected error occurred')),
    );
  }
}