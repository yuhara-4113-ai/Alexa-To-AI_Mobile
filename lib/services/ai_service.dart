// Flutterとその他のパッケージをインポート
import 'package:alexa_to_ai/database/database.dart';
import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/models/setting_screen_model.dart';
import 'package:alexa_to_ai/services/ai_agent/ai_agent.dart';
import 'package:alexa_to_ai/services/ai_agent/chat_gpt_agent.dart';
import 'package:alexa_to_ai/services/ai_agent/claude_agent.dart';
import 'package:alexa_to_ai/services/ai_agent/gemini_agent.dart';
import 'package:flutter/material.dart';

class AIService {
  // AIのリクエストなどを管理するクラス(実行時に各AIの分岐で設定)
  late AIAgent _aiAgent;

  /// AIにリクエストを送信
  /// prompt: ユーザのチャット入力内容に「設定内容(キャラクター、口調など)」を付与した文字列
  Future<String> sendMessageToAi(String prompt) async {
    debugPrint('prompt=$prompt');

    // 設定画面で保存した内容をローカルDBから取得
    final settingModel = settingModelBox.get(settingModelBoxKey);
    AIModel aiModel = settingModel!.getApiKeyForType();

    // 選択したAIの種別によって、処理を分ける
    switch (settingModel.getKeyFromSelectedType()) {
      case AITypes.chatGPT:
        debugPrint('call ChatGPTAgent');
        _aiAgent = ChatGPTAgent();
        break;
      case AITypes.gemini:
        debugPrint('call GeminiAgent');
        _aiAgent = GeminiAgent();
        break;
      case AITypes.claude:
        debugPrint('call ClaudeAgent');
        _aiAgent = ClaudeAgent();
        break;
    }
    // 各AIにリクエストを送信
    Future<String> responseText = _aiAgent.sendMessage(prompt, aiModel);
    return responseText;
  }
}
