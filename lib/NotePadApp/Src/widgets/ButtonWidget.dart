import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  ButtonWidget({required this.text, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
              onPressed: onClicked,
              child: Text(text, style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60),
                backgroundColor: const Color.fromARGB(255, 255, 74, 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
  }
}