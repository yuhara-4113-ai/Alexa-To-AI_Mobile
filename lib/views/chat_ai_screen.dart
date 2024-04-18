// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../database/database.dart';
import '../models/setting_screen_model.dart';
import '../services/ai_service.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/drawer.dart';

import 'home_screen.dart';
import 'setting_screen.dart';

// ChatAIScreenという名前のStatefulWidgetを作成
class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  // 画面名
  static String name = 'AIチャット画面';

  @override
  ChatAIScreenState createState() => ChatAIScreenState();
}

// ChatAIScreenの状態を管理するクラス
class ChatAIScreenState extends State<ChatAIScreen> {
  // 設定画面で保存した内容をローカルDBから取得
  final settingModel = settingModelBox.get(settingModelBoxKey);

  List<types.Message> messages = []; // メッセージを格納するリスト
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _ai = const types.User(id: '82091008-a484-4a89-ae75-hjgvhkjbig44');

  bool _isSettingSaved = true; // 設定が保存されているかどうか(送信ボタンなどの活性/非活性を切り替える際に使用)

  late AIService aiService;

  // 画面描画後に1度だけ呼び出されるメソッド
  @override
  void initState() {
    super.initState();
    aiService = AIService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ローカルDBに設定情報がない場合(初期インストール後に設定画面で保存してない場合など)
      // アラートを表示し、対象の画面要素を非活性(再描画)にする
      final settingModel = settingModelBox.get(settingModelBoxKey);
      if (settingModel == null) {
        _showAlertDialog();
        setState(() {
          _isSettingSaved = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChatAIScreen.name), // アプリバーのタイトル
      ),
      // ハンバーガーメニュー
      drawer: CustomDrawer(
        // TODO 今はtilesを各画面でコピペで定義している状態。各画面で自画面は非表示にできたら、シンプルにできる
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
            title: Text(SettingScreen.name),
            onTap: () {
              // 設定画面への遷移
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingScreen(
                        settingScreenModel: SettingScreenModel())),
              );
            },
          ),
        ],
      ),
      // 画面の主要な部分
      body: Chat(
        user: _user,
        messages: messages,
        onSendPressed: _onPressedSendButton,
      ),
      // body: Column(
      //   children: <Widget>[
      //     // メッセージの履歴
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: messages.length,
      //         itemBuilder: (context, index) {
      //           // メッセージを表示するリストタイルを作成
      //           return ListTile(
      //             title: Text(messages[index]),
      //           );
      //         },
      //       ),
      //     ),
      //     Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //       height: 70.0,
      //       child: Row(
      //         children: <Widget>[
      //           Expanded(
      //             child: TextField(
      //               controller: messageController, // テキストフィールドのコントローラー
      //               decoration: const InputDecoration(
      //                 hintText: 'メッセージを入力', // ヒントテキスト
      //               ),
      //               enabled: _isSettingSaved,
      //             ),
      //           ),
      //           // 送信ボタン
      //           Material(
      //             child: Center(
      //               child: Ink(
      //                 decoration: const ShapeDecoration(
      //                   color: Colors.blue,
      //                   shape: CircleBorder(),
      //                 ),
      //                 // 送信ボタン(本体)
      //                 child: IconButton(
      //                   icon: const Icon(
      //                     Icons.send,
      //                     color: Colors.white,
      //                   ),
      //                   onPressed: _isSettingSaved
      //                       // 活性
      //                       ? () {
      //                           _onPressedSendButton();
      //                         }
      //                       // 非活性
      //                       : null,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  /// 送信ボタンが押された際の処理
  void _onPressedSendButton(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);

    // メッセージをAIに送信
    _sendMessageToAi(message.text);
  }

  void _addMessage(types.Message message) {
    setState(() {
      messages.insert(0, message);
    });
  }

  /// 設定が未保存の場合にアラートを表示
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          titleValue: '設定が未保存です',
          contentValue: '設定画面で保存した後にメッセージの送信が行えます',
          onOkPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  /// ユーザの入力文字列をAIに送信
  void _sendMessageToAi(String message) async {
    // ユーザの入力文字列に設定内容を付与し、AIに送信するプロンプトを作成
    String prompt = createPrompt(message);
    // AIにリクエストを送信
    aiService.sendMessageToAi(prompt).then((responseText) {
      // AIからの返答をメッセージとして表示
      final textMessage = types.TextMessage(
        author: _ai,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: responseText,
      );

      _addMessage(textMessage);
    });
  }

  String createPrompt(String message) {
    // TODO AIに送信するプロンプトの作成は別ファイル(Utilとか？)の関数で定義する？
    // キャラクター名のプロンプト設定
    String aiNamePrompt = '';
    String aiName = settingModel!.aiName;
    if (aiName.isNotEmpty) {
      aiNamePrompt = '口調は$aiNameで';
    }
    // 性格のプロンプト設定
    // String aiPersonalityPrompt = '';
    // String aiPersonality = settingModel!.aiPersonality;
    // if (aiPersonality.isNotEmpty) {
    //   aiPersonalityPrompt = '性格は$aiPersonalityで、';
    // }
    // ユーザの入力文字列に設定内容を付与し、AIに送信するプロンプトを作成
    String prompt = aiNamePrompt + message;
    return prompt;
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
