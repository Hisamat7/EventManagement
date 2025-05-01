import 'package:flutter/material.dart';

class TextFormEtWidget extends StatefulWidget {
  final String label;
  final String? Function(String?)? validator;
  final String hint;
  final TextEditingController controller;
  const TextFormEtWidget({super.key, required this.label, this.validator, required this.hint, required this.controller});


  @override
  State<TextFormEtWidget> createState() => _TextFormEtWidgetState();
}

class _TextFormEtWidgetState extends State<TextFormEtWidget> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      style: const TextStyle(color: Colors.pinkAccent),
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.pinkAccent),
        hintText: widget.hint,
        labelText: widget.label,
        labelStyle: TextStyle(color: const Color.fromARGB(255, 235, 19, 91)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 250, 194, 213)),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}