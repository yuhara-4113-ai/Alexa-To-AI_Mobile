import 'package:alexa_to_ai/widgets/theme/custom_text_theme.dart';
import 'package:flutter/material.dart';

class LightThemeData {
  // constメソッドでメモリ効率とパフォーマンスを向上
  const LightThemeData();

  ThemeData build() {
    return ThemeData(
      // こことpubspec.yamlのfonts.familyの値を合わせないと指定したフォントが適用されない
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
                ? Colors.grey.shade700 // 非活性の場合
                : Colors.blueAccent;
          }),
          foregroundColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return states.contains(WidgetState.disabled)
                ? Colors.white // 非活性の場合
                : Colors.white;
          }),
        ),
      ),
      colorScheme: const ColorScheme.light(
        // プライマリカラー(アプリ全体で主要な色)
        primary: Colors.blueAccent,
        // セカンダリカラー(プライマリカラーの次に主要な色)
        secondary: Colors.white,
        // プライマリカラーの上に表示されるテキストやアイコンの色
        onPrimary: Colors.white,
        // セカンダリカラーの上に表示されるテキストやアイコンの色
        onSecondary: Colors.blueAccent,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: CustomTextTheme.build(),
      cardTheme: CardTheme(
        color: Colors.blue.shade50,
      ),
    );
  }
}
