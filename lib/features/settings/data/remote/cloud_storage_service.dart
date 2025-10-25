import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:alexa_to_ai/core/config/env.dart';
import 'package:alexa_to_ai/features/settings/domain/models/setting_screen_model.dart';

final String saveAISettingUrl = env[EnvKey.saveAISettingUrl]!;
final log = Logger();

class CloudStorageService {
  CloudStorageService._privateConstructor();
  static final CloudStorageService _instance =
      CloudStorageService._privateConstructor();
  factory CloudStorageService() => _instance;

  Future<bool> saveAISettingData(
    SettingScreenModel saveData,
    String idToken,
  ) async {
    final String apiKey = env[EnvKey.awsXApiKey]!;
    final String body = saveData.convertJsonToCloudSave();
    log.i('saveAISetting body: $body');

    final http.Response response = await http.post(
      Uri.parse(saveAISettingUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-api-key': apiKey,
        'Authorization': idToken,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      log.i('saveAISetting API 成功: ${response.body}');
      return true;
    } else {
      log.e('saveAISetting API 失敗: ${response.body}');
      return false;
    }
  }
}
