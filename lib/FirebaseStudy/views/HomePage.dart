import 'package:firebaselearning/FirebaseStudy/views/ProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildButton({required String title,required VoidCallback onPress}) {
    return  ElevatedButton(onPressed: onPress, child: Text(title,style: TextStyle(color: Colors.black),),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 80),
              backgroundColor: Colors.yellowAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                
              )
            ),
            
            );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
           _buildButton(title: "User", onPress: (){}),
            SizedBox(
              height: 30.h,
            ),
            _buildButton(title: "Products", onPress: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen()));
            })
          ],
        ),
      ),
    );
  }
}