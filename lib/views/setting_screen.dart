// 必要なパッケージとファイルをインポート
import 'package:flutter/material.dart'; // Flutterのマテリアルデザインパッケージ
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database.dart';
import '../models/setting_screen_model.dart';
import '../providers/setting_screen_model_provider.dart';
import '../widgets/drawer.dart';

import 'home_screen.dart';
import 'chat_ai_screen.dart';

// 設定画面の状態を管理する StatefulWidget
class SettingScreen extends HookConsumerWidget {
  // コンストラクタ SettingScreenModelを受け取る
  final SettingScreenModel settingScreenModel;
  const SettingScreen({Key? key, required this.settingScreenModel})
      : super(key: key);

  // 画面名
  static String name = '設定画面';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態保持している設定画面のmodelを取得
    final settingScreenModelProvider = ref.watch(settingScreenModelState);
    // todo 画面の初期化時にローカルDBから設定を取得

    // TextEditingControllerのインスタンスを作成します
    final aiNameController = TextEditingController();
    // 初期化時にテキストフィールドの初期値を設定します
    aiNameController.text = settingScreenModelProvider.aiName;

    // Scaffoldを使用して基本的なレイアウトを作成
    return Scaffold(
      appBar: AppBar(
        title: Text(name), // アプリバーのタイトル
      ),
      drawer: CustomDrawer(
        // todo 今はtilesを各画面でコピペで定義している状態。各画面で自画面は非表示にできたら、シンプルにできる
        tiles: [
          ListTile(
            title: Text(HomeScreen.name),
            onTap: () {
              // ホーム画面への遷移
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            title: Text(ChatAIScreen.name),
            onTap: () {
              // AIチャット画面への遷移
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ChatAIScreen()),
              );
            },
          ),
        ],
      ),
      // 画面の主要な部分
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // フォームの項目(定義順に縦に並べる)
          children: [
            // 呼び名の入力フォーム
            TextField(
              controller: aiNameController, // 初期値
              decoration: const InputDecoration(labelText: '呼び名'),
              onChanged: (value) {
                settingScreenModelProvider.aiName = value;
              },
            ),
            // 性格の入力フォーム
            DropdownButtonFormField(
              value: settingScreenModelProvider.aiPersonality, // 初期値
              // ドロップダウン項目の定義
              items: SettingScreenModel.aiPersonalityList
                  .map((label) => DropdownMenuItem(
                        value: label, // 各項目の値を設定します
                        child: Text(label), // 各項目のラベルを設定します
                      ))
                  .toList(), // ドロップダウンの項目をリストとして設定します
              onChanged: (value) {
                settingScreenModelProvider.aiPersonality = value!;
              },
              decoration:
                  const InputDecoration(labelText: '性格'), // フォームのラベルを設定します
            ),
            // 口調の入力フォーム
            DropdownButtonFormField(
              value: settingScreenModelProvider.aiTone, // 初期値
              // ドロップダウン項目の定義
              items: SettingScreenModel.aiToneList
                  .map((label) => DropdownMenuItem(
                        value: label, // 各項目の値を設定します
                        child: Text(label), // 各項目のラベルを設定します
                      ))
                  .toList(), // ドロップダウンの項目をリストとして設定します
              onChanged: (value) {
                settingScreenModelProvider.aiTone = value!;
              },
              decoration:
                  const InputDecoration(labelText: '口調'), // フォームのラベルを設定します
            ),
            // 保存ボタン
            const SizedBox(height: 20), // フォームとボタンの間にスペースを作成します
            ElevatedButton(
              onPressed: () {
                _saveSettings(
                    settingScreenModelProvider); // ボタンが押されたときに、_saveSettingsメソッドを呼び出します
              },
              child: const Text('保存'), // ボタンのラベルを設定します
            ),
          ],
        ),
      ),
    );
  }

  /// `_saveSettings`メソッドは、設定をローカルDBに保存
  Future<void> _saveSettings(SettingScreenModel model) async {
    // tdoo スナックバーで保存しましたを表示
    debugPrint(
        '保存しました: 名前=${model.aiName}, 性格=${model.aiPersonality}, 口調=${model.aiTone}');
    // ローカルDBに保存
    Box<SettingScreenModel> settingModelBox =
        await Hive.openBox<SettingScreenModel>(settingModelBoxName);
    settingModelBox.put(settingModelBoxKey, model);
  }
}
