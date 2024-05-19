import 'package:alexa_to_ai/database/database.dart';
import 'package:alexa_to_ai/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          themeMode: ThemeMode.system,
          // テーマの設定(ダークモード)
          darkTheme: ThemeData(
            fontFamily: 'NotoSansJP',
            brightness: Brightness.dark,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
            colorScheme: const ColorScheme.dark(
              primary: Colors.black,
              secondary: Colors.white,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
            ).copyWith(background: Colors.grey[850]),
          ),
          theme: ThemeData(
            // こことpubspec.yamlのfonts.familyの値を合わせないと指定したフォントが適用されない
            fontFamily: 'NotoSansJP',
            // 画面で共通のテーマ設定
            primarySwatch: Colors.deepPurple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: const TextTheme(
              titleLarge:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              bodyMedium: TextStyle(fontSize: 16.0),
            ),
          ),
          home: const Footer(),
        ),
      ),
    );
  }
}
