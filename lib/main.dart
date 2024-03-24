// Flutterとその他のパッケージをインポート
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ホーム画面のインポート
import 'views/home_screen.dart';

// アプリケーションのエントリーポイント
void main() {
  // runApp関数でアプリケーションを起動します
  runApp(
    // 各画面の入力状態の保持に使用するProviderScope
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'NotoSansJP',
        ),
        home: const HomeScreen(),
      ),
    ),
  );
}
