import 'package:alexa_to_ai/widgets/theme/custom_text_theme.dart';
import 'package:flutter/material.dart';

class DarkThemeData {
  // constメソッドでメモリ効率とパフォーマンスを向上
  const DarkThemeData();

  ThemeData build() {
    return ThemeData(
      // こことpubspec.yamlのfonts.familyの値を合わせないと指定したフォントが適用されない
      fontFamily: 'NotoSansJP',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade800,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return states.contains(WidgetState.disabled)
                ? Colors.black // 非活性の場合
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
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedIconTheme: IconThemeData(size: 24, color: Colors.lightBlue),
        unselectedIconTheme: IconThemeData(size: 24, color: Colors.grey),
      ),
      colorScheme: const ColorScheme.dark(
        // プライマリカラー(アプリ全体で主要な色)
        primary: Colors.blueAccent,
        // セカンダリカラー(プライマリカラーの次に主要な色)
        secondary: Colors.white,
        // プライマリカラーの上に表示されるテキストやアイコンの色
        onPrimary: Colors.white,
        // セカンダリカラーの上に表示されるテキストやアイコンの色
        onSecondary: Colors.blueAccent,
      ),
      textTheme: CustomTextTheme.build(),
      cardTheme: const CardTheme(
        color: Colors.black,
      ),
    );
  }
}
