import 'package:alexa_to_ai/widgets/theme/custom_text_theme.dart';
import 'package:flutter/material.dart';

class LightThemeData {
  ThemeData build() {
    return ThemeData(
      // こことpubspec.yamlのfonts.familyの値を合わせないと指定したフォントが適用されない
      fontFamily: 'NotoSansJP',
      // 画面で共通のテーマ設定
      primarySwatch: Colors.deepPurple,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: CustomTextTheme().build(),
    );
  }
}
