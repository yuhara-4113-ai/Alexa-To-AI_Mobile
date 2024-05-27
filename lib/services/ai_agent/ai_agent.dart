import 'package:alexa_to_ai/models/ai_model.dart';

/// AIエージェントの抽象クラス
/// ChatGPT、GeminiなどのAIエージェントはこのクラスを継承して作成する
abstract class AIAgent {
  Future<String> sendMessage(String prompt, AIModel aiModel);
}
