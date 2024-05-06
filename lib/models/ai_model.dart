// AIの種別(ChatGPT、Geminiなど)
import 'package:hive/hive.dart';
part 'ai_model.g.dart';

@HiveType(typeId: 1)
class AIModel extends HiveObject {
  // APIキー
  @HiveField(0)
  String apiKey;

  // モデル(ChatGPT-Turbo、ChatGPT-4など)
  @HiveField(1)
  String model;

  // AIModelのコンストラクタ
  AIModel({this.apiKey = '', this.model = ''});

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
