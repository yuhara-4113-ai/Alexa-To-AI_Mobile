import 'package:alexa_to_ai/widgets/theme/custom_text_theme.dart';
import 'package:flutter/material.dart';

class DarkThemeData {
  ThemeData buildThemeData() {
    return ThemeData(
      fontFamily: 'NotoSansJP',
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.black,
        secondary: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      ).copyWith(background: Colors.grey[850]),
      textTheme: CustomTextTheme().buildTextTheme(),
    );
  }
}
