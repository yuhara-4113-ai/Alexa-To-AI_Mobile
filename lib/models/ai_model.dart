// AIの種別(ChatGPT、Geminiなど)
import 'package:hive/hive.dart';
part 'ai_model.g.dart';

@HiveType(typeId: 1)
class AIModel extends HiveObject {
  // APIキー
  @HiveField(0)
  String apiKey;

  // AIのモデル(ChatGPT-Turbo、ChatGPT-4など)
  @HiveField(1)
  String model;

  // AIModelのコンストラクタ
  // 引数がなければChatGPTのデフォルト値を設定
  AIModel({String? apiKey, String? model})
      : apiKey = apiKey ?? '',
        model = model ?? modelConfig[aiType[AITypes.chatGPT]!]![0];

  // AIModel.fromメソッド
  // 既存のAIModelインスタンスを引数に取り、そのプロパティをコピーして新しいAIModelインスタンスを作成
  AIModel.from(AIModel ai)
      : apiKey = ai.apiKey,
        model = ai.model;

  // SettingScreenModelのtoJson2()使う用(二重エンコードになるのでここではエンコードしない)
  Map<String, String> toJson() {
    return {
      'apiKey': apiKey,
      'model': model,
    };
  }
}

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

// モデルをベタ書きするのはここだけ
final Map<AITypes, List<String>> modelConfig = {
  AITypes.chatGPT: ['gpt-3.5-turbo', 'gpt-4-turbo', 'gpt-4o'],
  AITypes.gemini: [
    'gemini-1.0-pro-latest',
    'gemini-1.5-flash-latest',
    'gemini-1.5-pro-latest',
  ],
  AITypes.claude: [
    'claude-3-haiku-20240307',
    'claude-3-sonnet-20240229',
    'claude-3-opus-20240229'
  ],
};
