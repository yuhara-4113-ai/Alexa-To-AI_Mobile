import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:alexa_to_ai/models/env.dart';
import 'package:alexa_to_ai/models/setting_screen_model.dart';

String saveAISettingUrl = env[EnvKey.saveAISettingUrl]!;

class CloudStorageService {
  /// クラウド環境に保存した設定内容を送信
  Future<bool> saveAISettingData(SettingScreenModel saveData) async {
    // 実行するAPIはパブリックのため、簡易的なapiKeyで認証をしている(アプリは公開しないため、apiKeyは.envから取得)
    // ※アプリを公開するなら解析されてapiKeyが盗まれる可能性がある。その場合はちゃんとした認証(Cognitoなど)を行った上でAPIを実行する
    String apiKey = env[EnvKey.awsXApiKey]!;

    final http.Response response = await http.post(
      Uri.parse(saveAISettingUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-api-key': apiKey,
      },
      body: saveData.toJson(),
    );

    if (response.statusCode == 200) {
      debugPrint('saveAISetting API 成功: ${response.body}');
      return true;
    } else {
      // TODO 失敗の場合は呼び元でモーダルを表示するなどの処理を行う
      debugPrint('saveAISetting API 失敗 statusCode: ${response.statusCode}');
      return false;
    }
  }
}
