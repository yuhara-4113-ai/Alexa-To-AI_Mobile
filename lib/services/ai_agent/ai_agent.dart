import 'package:alexa_to_ai/models/ai_model.dart';

/// AIエージェントの抽象クラス
/// ChatGPT、GeminiなどのAIエージェントはこのクラスを継承して作成する
abstract class AIAgent {
  /// 指定されたプロンプトとAIモデルに基づき、AIエージェントがレスポンスを生成する
  ///
  /// [prompt] AIに送信するメッセージのテキスト
  /// [aiModel] 使用するAIの情報を保持するModelオブジェクト
  ///
  /// 戻り値: AIからのレスポンス結果
  Future<String> sendMessage(String prompt, AIModel aiModel);
}
