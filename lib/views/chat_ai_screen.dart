// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:alexa_to_ai/database/database.dart';
import 'package:alexa_to_ai/models/setting_screen_model.dart';
import 'package:alexa_to_ai/services/ai_service.dart';
import 'package:alexa_to_ai/widgets/alert_dialog.dart';
import 'package:alexa_to_ai/widgets/drawer.dart';

import 'home_screen.dart';
import 'setting_screen.dart';

class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  // 画面名
  static String name = 'AIチャット画面';

  @override
  ChatAIScreenState createState() => ChatAIScreenState();
}

class ChatAIScreenState extends State<ChatAIScreen> {
  // 設定画面で保存した内容をローカルDBから取得
  final settingModel = settingModelBox.get(settingModelBoxKey);

  List<types.Message> messages = []; // メッセージを格納するリスト
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _ai = const types.User(id: '82091008-a484-4a89-ae75-hjgvhkjbig44');

  late AIService aiService;

  // 画面描画後に1度だけ呼び出されるメソッド
  @override
  void initState() {
    super.initState();
    aiService = AIService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ローカルDBに未保存のない場合(初期インストール後に設定画面で保存してない場合など)
      // アラートを表示し、保存を促す
      final settingModel = settingModelBox.get(settingModelBoxKey);
      if (!settingModel!.isSaved) {
        _showAlertDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // アプリバーのタイトル以下のように使用中のAIを表示
        // AIチャット画面(ChatGPT)
        title: Text('${ChatAIScreen.name}(${settingModel!.selectedType})'),
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
          contentValue: '設定画面でAIの口調などがカスタマイズできます',
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
    // 口調のプロンプト設定
    String aiTonePrompt = '';
    String aiTone = settingModel!.aiTone;
    if (aiTone.isNotEmpty) {
      aiTonePrompt = '口調は$aiToneで';
    }
    // ユーザの入力文字列に設定内容を付与し、AIに送信するプロンプトを作成
    String prompt = aiTonePrompt + message;
    return prompt;
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
