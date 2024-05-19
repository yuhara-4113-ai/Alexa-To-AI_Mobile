import 'dart:convert';
import 'dart:math';
import 'package:alexa_to_ai/database/database.dart';
import 'package:alexa_to_ai/services/ai_service.dart';
import 'package:alexa_to_ai/widgets/barrel/chat_ai_screen_widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatAIScreen extends StatefulWidget {
  // 画面名
  static String name = 'AIチャット画面';

  const ChatAIScreen({super.key});

  @override
  ChatAIScreenState createState() => ChatAIScreenState();
}

class ChatAIScreenState extends State<ChatAIScreen> {
  // 設定画面で保存した内容をローカルDBから取得
  final settingModel = settingModelBox.get(settingModelBoxKey);

  // メッセージを格納するリスト
  List<types.Message> messages = [];

  // AIのユーザ情報(名前に使用するAIの情報を使用するので後で初期化)
  late types.User _ai;
  // ユーザ情報
  final _user = const types.User(
    id: 'user',
  );

  late AIService aiService;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: AppBar(
        // アプリバーのタイトル以下のように使用中のAIを表示
        // AIチャット画面(ChatGPT)
        title: Text('${ChatAIScreen.name}(${settingModel!.selectedType})'),
      ),
      // 画面の主要な部分
      body: Chat(
        theme: brightness == Brightness.light
            ? const DefaultChatTheme(
                inputBackgroundColor: Colors.blueAccent, // メッセージ入力欄の背景色
                primaryColor: Colors.blueAccent, // メッセージの背景色
                userAvatarNameColors: [Colors.blueAccent], // ユーザー名の文字色
              )
            : DarkChatTheme(
                inputBackgroundColor: Colors.black, // メッセージ入力欄の背景色
                userAvatarNameColors: const [Colors.white70],
                backgroundColor: Colors.grey[850]!,
              ),
        user: _user,
        messages: messages,
        onSendPressed: _onPressedSendButton,
        showUserAvatars: true,
        showUserNames: true,
      ),
    );
  }

  String createPrompt(String message) {
    // 口調のプロンプト設定
    String aiTonePrompt = '';
    String aiTone = settingModel!.aiTone;
    if (aiTone.isNotEmpty) {
      aiTonePrompt = '口調は$aiTone。';
    }
    // TODO 最大文字数を設定画面でも可能に
    String maxCharLimit = '回答は200文字以内。';

    // ユーザの入力文字列に設定内容を付与し、AIに送信するプロンプトを作成
    String prompt = maxCharLimit + aiTonePrompt + message;
    return prompt;
  }

  // 画面描画後に1度だけ呼び出されるメソッド
  @override
  void initState() {
    super.initState();
    aiService = AIService();

    // チャットで表示するAIのユーザ情報を初期化
    _ai = types.User(
      id: 'ai',
      // 使用するAI
      firstName: settingModel!.selectedType,
      // AIのモデル
      lastName: settingModel!.getAIModel().model,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ローカルDBに未保存のない場合(初期インストール後に設定画面で保存してない場合など)
      // アラートを表示し、保存を促す
      if (!settingModel!.isSaved) {
        _showAlertDialog();
      }
    });
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _addMessage(types.Message message) {
    setState(() {
      messages.insert(0, message);
    });
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

  /// ユーザの入力文字列をAIに送信
  void _sendMessageToAi(String message) async {
    // ユーザの入力文字列に設定内容を付与し、AIに送信するプロンプトを作成
    String prompt = createPrompt(message);

    // AIの処理時間の計測開始
    Stopwatch timeTracker = Stopwatch()..start();

    // AIにリクエストを送信
    aiService.sendMessageToAi(prompt).then((responseText) {
      // AIからの返答をメッセージとして表示
      final aiTextMessage = types.TextMessage(
        author: _ai,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: responseText,
      );

      // AIの処理時間の計測終了
      timeTracker.stop();

      // 処理時間を秒単位で取得
      double time = timeTracker.elapsedMilliseconds / 1000;
      final timeTrackerTextMessage = types.TextMessage(
        author: _ai,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: '処理時間: $time秒',
      );
      // 処理時間を表示
      _addMessage(timeTrackerTextMessage);

      // AIのメッセージを表示
      _addMessage(aiTextMessage);
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
}
