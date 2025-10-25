import 'package:flutter/material.dart';

import 'package:alexa_to_ai/app/theme/custom_text_theme.dart';

class LightThemeData {
  const LightThemeData();

  ThemeData build() {
    return ThemeData(
      fontFamily: 'NotoSansJP',
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(size: 24, color: Colors.blueAccent),
        unselectedIconTheme: IconThemeData(size: 24, color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return states.contains(WidgetState.disabled)
                ? Colors.grey.shade700
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
      colorScheme: const ColorScheme.light(
        primary: Colors.blueAccent,
        secondary: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.blueAccent,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: CustomTextTheme.build(),
      cardTheme: CardThemeData(
        color: Colors.blue.shade50,
      ),
    );
  }
}
