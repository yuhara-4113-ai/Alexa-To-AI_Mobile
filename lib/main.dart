// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/home_screen.dart'; // ホーム画面のインポート

// アプリケーションのエントリーポイント
void main() {
  // runApp関数でアプリケーションを起動します
  runApp(
    // 各画面の入力状態の保持に使用するProviderScope
    const ProviderScope(
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}