import 'package:alexa_to_ai/widgets/theme/custom_text_theme.dart';
import 'package:flutter/material.dart';

class LightThemeData {
  ThemeData build() {
    return ThemeData(
      // こことpubspec.yamlのfonts.familyの値を合わせないと指定したフォントが適用されない
      fontFamily: 'NotoSansJP',
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(size: 30, color: Colors.blueAccent),
        unselectedIconTheme: IconThemeData(size: 24, color: Colors.grey),
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
      // 作成したカラースキームを元に新しいカラースキームを作成。
      // copyWithメソッドを使用することで、既存のカラースキームを部分的に変更する
      // .copyWith(background: Colors.white),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: CustomTextTheme().build(),
    );
  }
}
