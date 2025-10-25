import 'package:logger/logger.dart';

import 'package:alexa_to_ai/features/chat/data/agents/ai_agent.dart';
import 'package:alexa_to_ai/features/chat/data/agents/chat_gpt_agent.dart';
import 'package:alexa_to_ai/features/chat/data/agents/claude_agent.dart';
import 'package:alexa_to_ai/features/chat/data/agents/gemini_agent.dart';
import 'package:alexa_to_ai/features/settings/data/local/settings_hive_box.dart';
import 'package:alexa_to_ai/features/settings/domain/models/ai_model.dart';

final log = Logger();

class AIService {
  AIService._privateConstructor();
  static final AIService _instance = AIService._privateConstructor();
  factory AIService() => _instance;

  late AIAgent _aiAgent;

  Future<String> sendMessageToAi(String prompt) async {
    log.i('prompt=$prompt');

    final settingModel = settingModelBox.get(settingModelBoxKey);
    final AIModel aiModel = settingModel!.getAIModel();

    switch (AITypes.getAITypeByName(settingModel.selectedType)) {
      case AITypes.chatGPT:
        log.i('call ChatGPTAgent');
        _aiAgent = ChatGPTAgent();
        break;
      case AITypes.gemini:
        log.i('call GeminiAgent');
        _aiAgent = GeminiAgent();
        break;
      case AITypes.claude:
        log.i('call ClaudeAgent');
        _aiAgent = ClaudeAgent();
        break;
    }

    final Future<String> responseText = _aiAgent.sendMessage(prompt, aiModel);
    return responseText;
  }
}
