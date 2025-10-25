import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:alexa_to_ai/features/chat/data/services/ai_service.dart';
import 'package:alexa_to_ai/features/chat/presentation/providers/ai_service_provider.dart';
import 'package:alexa_to_ai/features/chat/presentation/theme/custom_dark_chat_theme.dart';
import 'package:alexa_to_ai/features/chat/presentation/theme/custom_default_chat_theme.dart';
import 'package:alexa_to_ai/features/settings/data/local/settings_hive_box.dart';
import 'package:alexa_to_ai/shared/widgets/notification/custom_alert_dialog.dart';

class ChatAIScreen extends ConsumerStatefulWidget {
  static String name = 'AIチャット画面';

  const ChatAIScreen({super.key});

  @override
  ChatAIScreenState createState() => ChatAIScreenState();
}

class ChatAIScreenState extends ConsumerState<ChatAIScreen> {
  late final AIService aiService;
  final settingModel = settingModelBox.get(settingModelBoxKey)!;
  List<types.Message> messages = [];
  late types.User _ai;
  final types.User _user = const types.User(id: 'user');

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      appBar: AppBar(
        title: Text('${ChatAIScreen.name}(${settingModel.selectedType})'),
      ),
      body: Chat(
        theme: brightness == Brightness.light
            ? CustomDefaultChatTheme().build()
            : CustomDarkChatTheme().build(),
        user: _user,
        messages: messages,
        onSendPressed: _onPressedSendButton,
        showUserAvatars: true,
        showUserNames: true,
      ),
    );
  }

  String createPrompt(String message) {
    String aiTonePrompt = '';
    final String aiTone = settingModel.aiTone;
    if (aiTone.isNotEmpty) {
      aiTonePrompt = '口調は$aiTone';
    }
    const String maxCharLimit = '200';

    final String tempPrompt = '''
    # 前提
    回答は$maxCharLimit文字以内で要約し、わかりやすく
    $aiTonePrompt
    # 質問
    $message
    ''';

    final String prompt = tempPrompt
        .split('\n')
        .map((line) => line.replaceFirst(RegExp(r'^ '), ''))
        .join('\n');

    return prompt;
  }

  @override
  void initState() {
    super.initState();

    aiService = ref.read(aiServiceProvider);

    _ai = types.User(
      id: 'ai',
      firstName: settingModel.selectedType,
      lastName: settingModel.getAIModel().model,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!settingModel.isSaved) {
        _showAlertDialog();
      }
    });
  }

  String randomString() {
    final Random random = Random.secure();
    final List<int> values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _addMessage(types.Message message) {
    setState(() {
      messages.insert(0, message);
    });
  }

  void _onPressedSendButton(types.PartialText message) {
    final types.TextMessage textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
    _sendMessageToAi(message.text);
  }

  void _sendMessageToAi(String message) async {
    final String prompt = createPrompt(message);

    final Stopwatch timeTracker = Stopwatch()..start();

    aiService.sendMessageToAi(prompt).then((responseText) {
      final types.TextMessage aiTextMessage = types.TextMessage(
        author: _ai,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: responseText,
      );

      timeTracker.stop();

      final double time = timeTracker.elapsedMilliseconds / 1000;
      final types.TextMessage timeTrackerTextMessage = types.TextMessage(
        author: _ai,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: '処理時間: $time秒',
      );
      _addMessage(timeTrackerTextMessage);

      _addMessage(aiTextMessage);
    });
  }

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
