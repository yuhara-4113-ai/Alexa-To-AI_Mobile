// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'setting_screen.dart';

// httpパッケージをインポート
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// ChatAIScreenという名前のStatefulWidgetを作成
class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('AIチャット画面'), // アプリバーのタイトル
      ),
      // ハンバーガーメニュー
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'メニュー', // ドロワーヘッダーのテキスト
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // ハンバーガーメニューの中身
            ListTile(
              title: const Text('ホーム画面'),
              onTap: () {
                // ホーム画面への遷移
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            // ハンバーガーメニューの中身
            ListTile(
              title: const Text('設定画面'),
              onTap: () {
                // 設定画面への遷移
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingScreen()),
                );
              },
            ),
          ],
        ),
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

  // todo ここにAIへのリクエスト処理を追加

  // // Define the API endpoint
  // String apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';

  // // Define the headers for the API request
  // Map<String, String> headers = {
  //   'Content-Type': 'application/json',
  //   'Authorization': 'Bearer YOUR_API_KEY'
  // };

  // // Define the body of the API request
  // String body = json.encode({'prompt': message, 'max_tokens': 60});

  // // Make the API request
  // http.Response response = await http.post(
  //   Uri.parse(apiUrl),
  //   headers: headers,
  //   body: body,
  // );

  // // Parse the API response
  // Map<String, dynamic> apiResponse = json.decode(response.body);

  // // Print the API response
  // debugPrint('API Response: ${apiResponse['choices'][0]['text']}');
}
