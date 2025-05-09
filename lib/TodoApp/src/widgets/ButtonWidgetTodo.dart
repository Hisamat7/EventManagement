import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidgetTodo extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  const ButtonWidgetTodo({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPress, child: Text(text, style: TextStyle(color: Colors.white),
    ), 
    style: ElevatedButton.styleFrom(
      minimumSize: Size(200, 60),
      backgroundColor: Colors.orangeAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      )
    ),
    );
  }
}