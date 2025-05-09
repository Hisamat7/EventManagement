import 'package:flutter/material.dart';

class TextFieldWidgetTodo extends StatelessWidget {
 final TextEditingController controller;
 final String hintText;
 final String? Function(String?)? validator;
 final String label;
  const TextFieldWidgetTodo({Key? key,required this.controller,required this.hintText,required this.validator,required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      validator: validator,
              controller: controller,
              decoration:  InputDecoration(
                hintText: hintText,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrangeAccent),
                  borderRadius: BorderRadius.circular(10),),
                   focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                  borderRadius: BorderRadius.circular(10),),
                label: Text(label),
              ),
            );
  }
}