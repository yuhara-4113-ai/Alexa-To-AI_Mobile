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
        model = model ?? AITypes.chatGPT.models[0];

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
  chatGPT(name: 'ChatGPT', models: ['gpt-3.5-turbo', 'gpt-4-turbo', 'gpt-4o']),
  gemini(name: 'Gemini', models: [
    'gemini-1.0-pro-latest',
    'gemini-1.5-flash-latest',
    'gemini-1.5-pro-latest'
  ]),
  claude(name: 'Claude', models: [
    'claude-3-haiku-20240307',
    'claude-3-sonnet-20240229',
    'claude-3-opus-20240229'
  ]);

  final String name;
  final List<String> models;

  const AITypes({required this.name, required this.models});

  static AITypes getAIType(String name) {
    return AITypes.values.firstWhere((entry) => entry.name == name);
  }
}
