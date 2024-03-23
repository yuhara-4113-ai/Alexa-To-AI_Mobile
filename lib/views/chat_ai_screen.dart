// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import '../models/setting_screen_mdel.dart';
import '../widgets/drawer.dart';
import 'home_screen.dart';
import 'setting_screen.dart';

// ChatAIScreenという名前のStatefulWidgetを作成
class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  // 画面名取得
  get name => 'AIチャット画面';

  @override
  ChatAIScreenState createState() => ChatAIScreenState();
}

// ChatAIScreenの状態を管理するクラス
class ChatAIScreenState extends State<ChatAIScreen> {
  List<String> messages = []; // メッセージを格納するリスト
  TextEditingController messageController =
      TextEditingController(); // メッセージ入力のコントローラー

  @override
  Widget build(BuildContext context) {
    const homeScreen = HomeScreen();
    final settingScreen =
        SettingScreen(settingScreenModel: SettingScreenModel());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name), // アプリバーのタイトル
      ),
      // ハンバーガーメニュー
      drawer: CustomDrawer(
        // todo 今はtilesを各画面でコピペで定義している状態。各画面で自画面は非表示にできたら、シンプルにできる
        tiles: [
          ListTile(
            title: Text(homeScreen.name),
            onTap: () {
              // ホーム画面への遷移
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => homeScreen),
              );
            },
          ),
          ListTile(
            title: Text(settingScreen.name),
            onTap: () {
              // 設定画面への遷移
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => settingScreen),
              );
            },
          ),
        ],
      ),
      // 画面の主要な部分
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length, // メッセージの数
              itemBuilder: (context, index) {
                // メッセージを表示するリストタイルを作成
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 70.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController, // テキストフィールドのコントローラー
                    decoration: const InputDecoration(
                      hintText: 'メッセージを入力', // ヒントテキスト
                    ),
                  ),
                ),
                // 送信ボタン
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // メッセージが空でない場合に送信処理を行う
                    if (messageController.text.isNotEmpty) {
                      // メッセージをAIに送信
                      _sendMessageToAi(messageController.text);
                      // Stateの更新
                      setState(() {
                        // 入力されたメッセージをリストに追加(チャット履歴として表示)
                        messages.add(messageController.text);
                        // メッセージ入力欄をクリア
                        messageController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `_sendMessage`メソッドは、ユーザの入力文字列をAIに送信します
void _sendMessageToAi(String message) async {
  debugPrint('送信しました: 名前=$message');
  // todo ここでai_service.dartのsendMessageToAiを呼び出す
}
