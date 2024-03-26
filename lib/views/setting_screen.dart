// 必要なパッケージとファイルをインポート
import 'package:flutter/material.dart'; // Flutterのマテリアルデザインパッケージ
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database.dart';
import '../models/setting_screen_model.dart';
import '../providers/setting_screen_model_provider.dart';
import '../widgets/drawer.dart';

import 'home_screen.dart';
import 'chat_ai_screen.dart';

// 設定画面の状態を管理する StatefulWidget
class SettingScreen extends HookConsumerWidget {
  // コンストラクタ 状態を保持しているModelを受け取る
  final SettingScreenModel settingScreenModel;
  const SettingScreen({Key? key, required this.settingScreenModel})
      : super(key: key);

  // 画面名
  static String name = '設定画面';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態保持している設定画面のmodelを取得
    final settingScreenModelProvider = ref.watch(settingScreenModelState);
    // 画面に表示する設定画面のmodelを取得
    _setViewnModel(settingScreenModelProvider);

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
              // todo 変更する度に状態保持に反映しており、無駄がある。フォーカスアウト時だけ検知できれば最低限の反映で済むが、実装が難しそうなので一旦このまま
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
    settingModelBox.put(settingModelBoxKey, model);
    // todo 以下のようにsave()でboxkeyを意識しないで保存できるようにしたい
    // model.save();
  }

  /// `_setViewModel`メソッドは、ローカルDBに保存されている設定がある場合は、状態保持中のmodelに設定を反映
  void _setViewnModel(SettingScreenModel settingScreenModelProvider) {
    final settingModel = settingModelBox.get(settingModelBoxKey);

    // 【現状の問題点】
    // 「状態保持中のmodel」と「ローカルDB」が存在する場合、初期表示時に「ローカルDB」が優先される
    // 入力中で別画面に遷移し、戻ってきた場合に入力中の内容が消えてしまい、ユーザビリティが悪い。
    // しかも、以下のようなケースで、「変更したのに反映されていないように見えるバグ」が発生する
    // 1. アプリの初回インストールでデータを入力
    // 2. 保存ボタンを押さずに別画面に遷移して設定画面に戻る
    // 3. データが残っており、保存されてるっぽいので、保存ボタンを押さずにチャット画面でAIにリクエストを送る
    // 4. ローカルDBには保存されていないため、性格や口調を初期値で送信してしまう

    // 【改善策】
    // 初期表示と変更中で「状態保持中のmodel」と「ローカルDB」をチェックする
    // 内容が異なる場合は「設定ボタン」の名前や色を変え、ユーザーに保存を促す
    //  パフォーマンスは多少悪くなるが、ユーザビリティを考えると必要な処理

    if (settingModel != null) {
      settingScreenModelProvider.aiName = settingModel.aiName;
      settingScreenModelProvider.aiPersonality = settingModel.aiPersonality;
      settingScreenModelProvider.aiTone = settingModel.aiTone;
    }
  }
}
