import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/services/ai_agent/ai_agent.dart';

final log = Logger();
const apiUrl = 'api.anthropic.com';
const endpoint = '/v1/messages';
const anthropicVersion = '2023-06-01';

class ClaudeAgent implements AIAgent {
  @override
  Future<String> sendMessage(String prompt, AIModel aiModel) async {
    final url = Uri.https(apiUrl, endpoint);
    final headers = _buildHeaders(aiModel.apiKey);

    final body = _buildRequestBody(prompt, aiModel.model);
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));
        return responseData['content'][0]['text'];
      } catch (e) {
        log.e('レスポンスのデコード中にエラーが発生しました: $e');
        throw Exception("AIリクエストの送信中にエラーが発生しました");
      }
    } else {
      log.e('HTTPエラーレスポンス: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception("AIリクエストの送信中にエラーが発生しました");
    }
  }

  Map<String, String> _buildHeaders(String apiKey) {
    return {
      'Content-Type': 'application/json',
      'X-API-Key': apiKey,
      'Anthropic-Version': anthropicVersion,
    };
  }

  String _buildRequestBody(String prompt, String model) {
    return jsonEncode({
      'model': model,
      'max_tokens': 500,
      'system': "",
      'messages': [
        {'role': 'user', 'content': prompt},
      ]
    });
  }
}
