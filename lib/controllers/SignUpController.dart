import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebaselearning/views/HomePage.dart'; // Ensure correct import

class SignUpController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context, // Added to show SnackBar & navigate
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );

      // Navigate to HomePage & remove previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false, // Clears all previous routes
      );
    } on FirebaseAuthException catch (e) {
      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up failed: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred")),
      );
    }
  }
}