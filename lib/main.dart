import 'package:firebase_core/firebase_core.dart';
import 'package:firebaselearning/firebase_options.dart';
import 'package:firebaselearning/hive_db/model/TodoModelHv.dart';
import 'package:firebaselearning/hive_db/views/HiveHome.dart';
import 'package:firebaselearning/hive_db/views/TodoHiveHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelHvAdapter());
  
  runApp(ScreenUtilInit(
    designSize: Size(384, 805),
    minTextAdapt: true,
    builder: (context, child) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Poppins',
          ),
          home: HiveHome());
    },
  ));
}

