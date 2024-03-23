// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'chat_ai_screen.dart'; // AIチャット画面のインポート
import 'setting_screen.dart'; // 設定画面のインポート

// ホーム画面
class HomeScreen extends StatelessWidget {
  // コンストラクタを定義します
  const HomeScreen({super.key});

  // buildメソッドをオーバーライドします
  @override
  Widget build(BuildContext context) {
    // Scaffoldウィジェットでアプリケーションの基本的なビジュアルレイアウトを構造する
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム画面'), // アプリバーのタイトルを設定します
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 子ウィジェットを中央に配置します
          children: [
            ElevatedButton(
              onPressed: () {
                // ボタンが押されたときに、設定画面に遷移します
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          // 遷移先の画面を設定します
                          const SettingScreen()),
                );
              },
              // ボタンのラベルを設定します
              child: const Text('設定画面へ'),
            ),
            // ボタン間のスペースを作成します
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ボタンが押されたときに、AIチャット画面に遷移します
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          // 遷移先の画面を設定します
                          const ChatAIScreen()),
                );
              },
              // ボタンのラベルを設定します
              child: const Text('AIチャット画面へ'),
            ),
          ],
        ),
      ),
    );
  }
}
