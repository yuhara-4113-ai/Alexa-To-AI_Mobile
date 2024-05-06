import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/services/ai_agent/ai_agent.dart';

class ClaudeAgent implements AIAgent {
  @override
  Future<String> sendMessage(String prompt, AIModel aiModel) async {
    // TODO 未実装。とりあえずは非同期で固定文字列を返却
    await Future.delayed(const Duration(seconds: 1));
    // 非同期操作が完了したら、String型の結果を返します。
    return 'Claude response. apiKey: ${aiModel.apiKey}';
  }
}
