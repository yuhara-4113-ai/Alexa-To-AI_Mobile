import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/services/ai_agent/ai_agent.dart';

final log = Logger();
final url = Uri.https('api.anthropic.com', '/v1/messages');

class ClaudeAgent implements AIAgent {
  @override
  Future<String> sendMessage(String prompt, AIModel aiModel) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-API-Key': aiModel.apiKey,
      'Anthropic-Version': '2023-06-01',
    };

    final body = jsonEncode({
      'model': aiModel.model,
      'max_tokens': 500,
      'system': "",
      'messages': [
        {'role': 'user', 'content': prompt},
      ]
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));
        return responseData['content'][0]['text'];
      } catch (e) {
        log.e('Error decoding response: $e');
        throw Exception("AIリクエストの送信中にエラーが発生しました");
      }
    } else {
      log.e('Error response: $response');
      throw Exception("AIリクエストの送信中にエラーが発生しました");
    }
  }
}
