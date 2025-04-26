import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselearning/NotePadApp/Src/Views/HomeScreenPage.dart';
import 'package:firebaselearning/NotePadApp/Src/Views/LoginScreenPage.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final _auth =FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (_auth.currentUser != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreenPage()));
      } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreenPage()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text("NotePad", style: TextStyle(color: Colors.yellowAccent),)),
    );
  }
}