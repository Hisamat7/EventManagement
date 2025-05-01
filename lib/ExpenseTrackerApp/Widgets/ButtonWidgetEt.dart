import 'package:flutter/material.dart';

class ButtonWidgetEt extends StatefulWidget {
  final String text;
  final VoidCallback onPress;
  const ButtonWidgetEt({ required this.text, required this.onPress});

  @override
  State<ButtonWidgetEt> createState() => _ButtonWidgetEtState();
}

class _ButtonWidgetEtState extends State<ButtonWidgetEt> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPress,
      child: Text(
        widget.text,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(200, 60),
        backgroundColor: const Color.fromARGB(255, 255, 87, 143),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
