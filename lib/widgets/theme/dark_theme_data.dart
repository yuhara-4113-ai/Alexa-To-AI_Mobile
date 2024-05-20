import 'package:alexa_to_ai/widgets/theme/custom_text_theme.dart';
import 'package:flutter/material.dart';

class DarkThemeData {
  ThemeData build() {
    return ThemeData(
      // こことpubspec.yamlのfonts.familyの値を合わせないと指定したフォントが適用されない
      fontFamily: 'NotoSansJP',
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedIconTheme: IconThemeData(size: 30, color: Colors.lightBlue),
        unselectedIconTheme: IconThemeData(size: 24, color: Colors.grey),
      ),
      colorScheme: const ColorScheme.dark(
        // プライマリカラー(アプリ全体で主要な色)
        primary: Colors.white,
        // セカンダリカラー(プライマリカラーの次に主要な色)
        secondary: Colors.lightBlueAccent,
        // プライマリカラーの上に表示されるテキストやアイコンの色
        onPrimary: Colors.lightBlueAccent,
        // セカンダリカラーの上に表示されるテキストやアイコンの色
        onSecondary: Colors.white,
      )
          // 作成したカラースキームを元に新しいカラースキームを作成。
          // copyWithメソッドを使用することで、既存のカラースキームを部分的に変更する
          .copyWith(background: Colors.grey[850]),
      textTheme: CustomTextTheme().build(),
    );
  }
}
