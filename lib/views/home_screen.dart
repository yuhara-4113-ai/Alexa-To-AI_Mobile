// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import '../widgets/home_screen_button.dart'; // ホーム画面ボタンのインポート
// 遷移する別画面のインポート
import 'chat_ai_screen.dart';
import 'setting_screen.dart';

// ホーム画面
class HomeScreen extends StatelessWidget {
  // コンストラクタを定義します
  const HomeScreen({super.key});

  // 画面名取得
  get name => 'ホーム画面';

  // buildメソッドをオーバーライドします
  @override
  Widget build(BuildContext context) {
    const settingScreen = SettingScreen();
    const chatAIScreen = ChatAIScreen();

    // Scaffoldウィジェットでアプリケーションの基本的なビジュアルレイアウトを構造する
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム画面'), // アプリバーのタイトルを設定します
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 子ウィジェットを中央に配置します
          children: [
            HomeScreenButton(
              screen: settingScreen,
              buttonText: settingScreen.name,
            ),
            HomeScreenButton(
              screen: chatAIScreen,
              buttonText: chatAIScreen.name,
            ),
          ],
        ),
      ),
    );
  }
}
