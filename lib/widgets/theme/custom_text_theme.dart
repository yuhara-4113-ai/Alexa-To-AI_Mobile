import 'package:flutter/material.dart';

class CustomTextTheme {
  TextTheme build() {
    return const TextTheme(
      titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 16.0),
    );
  }
}
