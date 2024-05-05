// AIの種別(ChatGPT、Geminiなど)
import 'dart:convert';

import 'package:hive/hive.dart';
part 'ai_model.g.dart';

enum AITypes {
  chatGPT,
  gemini,
  claude,
}

// AITypeをベタ書きするのはここだけ
final Map<AITypes, String> aiType = {
  AITypes.chatGPT: 'ChatGPT',
  AITypes.gemini: 'Gemini',
  AITypes.claude: 'Claude',
};

@HiveType(typeId: 1)
class AIModel extends HiveObject {
  // 種別(ChatGPT、Geminiなど)
  @HiveField(0)
  String type = '';

  // APIキー
  @HiveField(1)
  String apiKey = '';

  // モデル(ChatGPT-Turbo、ChatGPT-4など)
  @HiveField(2)
  String model = '';

  // AIModelのコンストラクタ
  AIModel();

  // SettingScreenModelのtoJson2()使う用(二重エンコードになるのでここではエンコードしない)
  Map<String, String> toJson() {
    return {
      'type': type,
      'apiKey': apiKey,
      'model': model,
    };
  }
}
