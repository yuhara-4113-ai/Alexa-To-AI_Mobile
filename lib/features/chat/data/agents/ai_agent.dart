import 'package:alexa_to_ai/features/settings/domain/models/ai_model.dart';

/// AI エージェントの抽象クラス
/// ChatGPT、Gemini などの AI エージェントはこのクラスを継承して実装する
abstract class AIAgent {
  /// 指定されたプロンプトと AI モデルに基づき、レスポンスを生成する
  Future<String> sendMessage(String prompt, AIModel aiModel);
}
