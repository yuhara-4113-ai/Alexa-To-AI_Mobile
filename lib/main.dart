// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/database.dart';
import 'views/home_screen.dart';

// アプリケーションのエントリーポイント
void main() async {
  // .envファイルの読み込み
  await dotenv.load();
  // アプリケーションが起動する際にローカルデータベースを初期化
  WidgetsFlutterBinding.ensureInitialized();
  // ローカルデータベースの初期化
  await initHive();
  // runApp関数でアプリケーションを起動します
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 各画面の入力状態の保持に使用するProviderScope
      home: ProviderScope(
        child: MaterialApp(
          theme: ThemeData(
            // こことpubspec.yamlのfonts.familyの値を合わせないと指定したフォントが適用されない
            fontFamily: 'NotoSansJP',
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
