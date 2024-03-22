// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'setting_screen.dart';

// Import the http package
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  @override
  ChatAIScreenState createState() => ChatAIScreenState();
}

class ChatAIScreenState extends State<ChatAIScreen> {
  List<String> messages = [];
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AIチャット画面'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'メニュー',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('ホーム画面'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('設定画面'),
              onTap: () {
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
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
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'メッセージを入力',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      _sendMessageToAi(messageController.text);
                      setState(() {
                        messages.add(messageController.text);
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

  // TODO ここにAIへのリクエスト処理を追加

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
