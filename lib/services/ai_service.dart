// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';

// httpパッケージをインポート
import 'package:http/http.dart' as http;
import 'dart:convert';

/// `sendMessageToAi`メソッドは、ユーザの入力文字列をAIに送信します
void sendMessageToAi(String message) async {
  debugPrint('送信しました: 名前=$message');

  // Define the API endpoint
  String apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';

  // Define the headers for the API request
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer YOUR_API_KEY'
  };

  // Define the body of the API request
  String body = json.encode({'prompt': message, 'max_tokens': 60});

  // Make the API request
  http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: body,
  );

  // Parse the API response
  Map<String, dynamic> apiResponse = json.decode(response.body);

  // Print the API response
  debugPrint('API Response: ${apiResponse['choices'][0]['text']}');
}
