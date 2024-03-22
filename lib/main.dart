// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'home_screen.dart'; // ホーム画面のインポート

// アプリケーションのエントリーポイント
void main() {
  // runApp関数でアプリケーションを起動します
  runApp(const MaterialApp(
    home: HomeScreen(), // HomeScreenをアプリケーションのホーム画面として設定します
  ));
}
