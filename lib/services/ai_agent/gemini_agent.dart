import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/services/ai_agent/ai_agent.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAgent implements AIAgent {
  @override
  Future<String> sendMessage(String prompt, AIModel aiModel) async {
    final model = GenerativeModel(model: aiModel.model, apiKey: aiModel.apiKey);

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    debugPrint('Response from gemini-pro: $response');

    return response.text!;
  }
}
