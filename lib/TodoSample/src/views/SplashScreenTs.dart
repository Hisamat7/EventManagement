import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselearning/TodoSample/src/views/HomePageTs.dart';
import 'package:firebaselearning/TodoSample/src/views/LoginPageTs.dart';
import 'package:flutter/material.dart';

class SplashScreenTs extends StatefulWidget {
  const SplashScreenTs({super.key});

  @override
  State<SplashScreenTs> createState() => _SplashScreenTsState();
}

class _SplashScreenTsState extends State<SplashScreenTs> {
  final auth =FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if(auth.currentUser != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageTs()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPageTs()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Splash Screen", style: TextStyle(color: Colors.yellowAccent,fontSize: 30,fontWeight: FontWeight.bold),)),
    );
  }
}