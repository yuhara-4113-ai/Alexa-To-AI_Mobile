// Claude agent placeholder (kept for parity with original project)
import 'package:logger/logger.dart';
import 'package:alexa_to_ai/features/ai_setting/models/ai_model.dart';
import 'package:alexa_to_ai/features/ai_chat/services/ai_agent/ai_agent.dart';

final log = Logger();

class ClaudeAgent implements AIAgent {
  @override
  Future<String> sendMessage(String prompt, AIModel aiModel) async {
    // 実装はプロジェクト側で定義
    log.i('ClaudeAgent.sendMessage called');
    return 'Claude agent not implemented';
  }
}
