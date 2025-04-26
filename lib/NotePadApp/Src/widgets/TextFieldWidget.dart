import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labeltext;
  final String hinttext;
   final String? Function(String?)? validator;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.hinttext,
    this.validator
  });

  @override
  State<TextFieldWidget> createState() => _TextfieldwidgetState();
}

class _TextfieldwidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        labelText: widget.labeltext,
        hintText: widget.hinttext,
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(

          borderSide: BorderSide(color: Colors.amberAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          
          borderSide: BorderSide(color: Colors.limeAccent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}