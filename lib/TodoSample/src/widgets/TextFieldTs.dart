import 'package:flutter/material.dart';

class TextFieldTs extends StatelessWidget {
  final String text;
  int? height;
  final TextEditingController controller;
   final String hintText;
   final String? Function(String?)? validator;
  TextFieldTs({required this.text, required this.controller,required this.hintText,required this.validator,this.height});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: height,
      validator: validator,
      controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              labelText: text,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.deepOrangeAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orangeAccent),
              ),
            ),
          );
  }
}