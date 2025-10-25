import 'package:flutter/material.dart';

import 'package:alexa_to_ai/app/theme/custom_text_theme.dart';

class DarkThemeData {
  const DarkThemeData();

  ThemeData build() {
    return ThemeData(
      fontFamily: 'NotoSansJP',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade800,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return states.contains(WidgetState.disabled)
                ? Colors.black
                : Colors.blueAccent;
          }),
          foregroundColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return states.contains(WidgetState.disabled)
                ? Colors.white
                : Colors.white;
          }),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedIconTheme: IconThemeData(size: 24, color: Colors.lightBlue),
        unselectedIconTheme: IconThemeData(size: 24, color: Colors.grey),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.blueAccent,
        secondary: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.blueAccent,
      ),
      textTheme: CustomTextTheme.build(),
      cardTheme: const CardThemeData(
        color: Colors.black,
      ),
    );
  }
}
