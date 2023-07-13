import 'package:flutter/material.dart';
class StyledTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  StyledTextButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        disabledForegroundColor: Colors.grey,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        side: const BorderSide(color: Color.fromARGB(255, 90, 66, 66), width: 2),
      ),
      onPressed: onPressed,
    );
  }
}
