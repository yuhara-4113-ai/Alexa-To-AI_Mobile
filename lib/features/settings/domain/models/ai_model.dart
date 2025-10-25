import 'package:hive/hive.dart';

part 'ai_model.g.dart';

// AI の種別 (ChatGPT、Gemini など)
@HiveType(typeId: 1)
class AIModel extends HiveObject {
  /// API キー
  @HiveField(0)
  String apiKey;

  /// AI のモデル (ChatGPT-Turbo、ChatGPT-4 など)
  @HiveField(1)
  String model;

  /// 引数がなければデフォルト値を設定 (ChatGPT)
  AIModel({String? apiKey, String? model})
      : apiKey = apiKey ?? '',
        model = model ?? AITypes.chatGPT.models[0];

  /// `AIModel` インスタンスをコピーし、新しいインスタンスを作成
  factory AIModel.from(AIModel ai) {
    return AIModel(apiKey: ai.apiKey, model: ai.model);
  }

  /// JSON 形式のマップに変換 (二重エンコード防止のためエンコードは行わない)
  Map<String, String> toJson() {
    return {
      'apiKey': apiKey,
      'model': model,
    };
  }
}

enum AITypes {
  chatGPT(name: 'ChatGPT', models: [
    'chatgpt-4o-latest',
    'gpt-4o-mini',
    'o1-preview',
    'o1-mini',
    'gpt-4.5-preview',
  ]),
  gemini(name: 'Gemini', models: [
    'gemini-1.5-pro-latest',
    'gemini-2.0-flash',
    'gemini-2.0-flash-exp',
    'gemini-2.0-flash-lite-preview',
    'gemini-2.0-flash-thinking-exp',
    'gemini-2.0-pro-exp',
  ]),
  claude(name: 'Claude', models: [
    'claude-3-haiku-20240307',
    'claude-3-sonnet-20240229',
    'claude-3-opus-latest',
    'claude-3-5-haiku-latest',
    'claude-3-5-sonnet-latest',
    'claude-3-7-sonnet-20250219',
  ]);

  final String name;
  final List<String> models;

  const AITypes({required this.name, required this.models});

  /// 名前から対応する AI タイプを取得
  static AITypes getAITypeByName(String name) {
    return AITypes.values.firstWhere(
      (entry) => entry.name == name,
      orElse: () => throw ArgumentError('Invalid AI type'),
    );
  }
}
