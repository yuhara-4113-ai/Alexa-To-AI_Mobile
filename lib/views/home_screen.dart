// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';

import 'package:alexa_to_ai/models/setting_screen_model.dart';
import 'package:alexa_to_ai/widgets/home_screen_button.dart';

import 'chat_ai_screen.dart';
import 'setting_screen.dart';

// ホーム画面
class HomeScreen extends StatelessWidget {
  // コンストラクタを定義します
  const HomeScreen({super.key});

  // 画面名
  static String name = 'ホーム画面';

  // buildメソッドをオーバーライドします
  @override
  Widget build(BuildContext context) {
    // Scaffoldウィジェットでアプリケーションの基本的なビジュアルレイアウトを構造する
    return Scaffold(
      // アプリバーのタイトルを設定します
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 子ウィジェットを中央に配置します
          children: [
            HomeScreenButton(
              screen: SettingScreen(settingScreenModel: SettingScreenModel()),
              buttonText: SettingScreen.name,
            ),
            HomeScreenButton(
              screen: const ChatAIScreen(),
              buttonText: ChatAIScreen.name,
            ),
          ],
        ),
      ),
    );
  }
}
