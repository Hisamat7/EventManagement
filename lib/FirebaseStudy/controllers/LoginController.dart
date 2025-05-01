import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselearning/FirebaseStudy/views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  FirebaseAuth auth = FirebaseAuth.instance;
  
  Future<void> login({
    required String email, 
    required String password, 
    required BuildContext context
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful")),
      );
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.message}")),
      );
    }
  }
  Future<void> googleLogin({required BuildContext context}) async {
   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
   final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth!.accessToken,
    idToken: googleAuth.idToken,
   );

   try {
    await auth.signInWithCredential(credential);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login successful")),
    );
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => HomePage()),
    );
   } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login failed: ${e.message}")),
    );
   }
  }
}