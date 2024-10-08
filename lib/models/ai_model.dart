// AIの種別(ChatGPT、Geminiなど)
import 'package:hive/hive.dart';
part 'ai_model.g.dart';

@HiveType(typeId: 1)
class AIModel extends HiveObject {
  /// APIキー
  @HiveField(0)
  String apiKey;

  /// AIのモデル (ChatGPT-Turbo、ChatGPT-4など)
  @HiveField(1)
  String model;

  /// AIModelのコンストラクタ
  /// 引数がなければ、デフォルト値を設定 (ChatGPT)
  AIModel({String? apiKey, String? model})
      : apiKey = apiKey ?? '',
        model = model ?? AITypes.chatGPT.models[0];

  /// `AIModel`インスタンスをコピーし、新しいインスタンスを作成するファクトリコンストラクタ
  factory AIModel.from(AIModel ai) {
    return AIModel(apiKey: ai.apiKey, model: ai.model);
  }

  /// JSON形式のマップに変換 (二重エンコード防止のためエンコードは行わない)
  Map<String, String> toJson() {
    return {
      'apiKey': apiKey,
      'model': model,
    };
  }
}

enum AITypes {
  chatGPT(name: 'ChatGPT', models: [
    'gpt-3.5-turbo',
    'gpt-4-turbo',
    'gpt-4o',
    'gpt-4o-mini',
    'o1-preview',
    'o1-mini',
  ]),
  gemini(name: 'Gemini', models: [
    'gemini-1.0-pro-latest',
    'gemini-1.5-flash-latest',
    'gemini-1.5-flash-8b-latest',
    'gemini-1.5-pro-latest',
  ]),
  claude(name: 'Claude', models: [
    'claude-3-haiku-20240307',
    'claude-3-sonnet-20240229',
    'claude-3-opus-20240229',
    'claude-3-5-sonnet-20240620',
  ]);

  final String name;
  final List<String> models;

  const AITypes({required this.name, required this.models});

  /// 名前から対応するAIタイプを取得
  static AITypes getAITypeByName(String name) {
    return AITypes.values.firstWhere((entry) => entry.name == name,
        orElse: () => throw ArgumentError('Invalid AI type'));
  }
}
