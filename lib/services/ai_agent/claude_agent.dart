import 'package:anthropic_dart/anthropic_dart.dart';
import 'package:flutter/foundation.dart';

import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/services/ai_agent/ai_agent.dart';

class ClaudeAgent implements AIAgent {
  static const apiUrl = 'https://api.anthropic.com/v1/messages';

  @override
  Future<String> sendMessage(String prompt, AIModel aiModel) async {
    final service = AnthropicService(aiModel.apiKey, model: aiModel.model);

    Request request = Request();
    // request.model = aiModel.model;
    request.maxTokens = 500;
    request.messages = [
      Message(
        role: "user",
        content: prompt,
      )
    ];
    Response response = await service.sendRequest(request: request);
    String responseText = response.toJson()["content"][0]["text"];
    debugPrint('Response body: $responseText');

    return responseText;
  }
}
