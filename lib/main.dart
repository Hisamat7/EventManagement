import 'package:firebase_core/firebase_core.dart';
import 'package:firebaselearning/NotePadApp/Src/Views/LoginScreenPage.dart';
import 'package:firebaselearning/NotePadApp/Src/Views/SplashScreenPage.dart';
import 'package:firebaselearning/firebase_options.dart';
import 'package:firebaselearning/views/LoginScreen.dart';
import 'package:firebaselearning/views/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ScreenUtilInit(
    designSize: Size(384, 805),
    minTextAdapt: true,
    builder: (context, child) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            
            fontFamily: 'Poppins',
          ),
          home: SplashScreenPage());
    },
  ));
}

