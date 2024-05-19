import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressedFunction;

  const CustomElevatedButton(
      {super.key, required this.text, required this.onPressedFunction});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedFunction,
      style: ElevatedButton.styleFrom(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      ),
      child: Text(text),
    );
  }
}
