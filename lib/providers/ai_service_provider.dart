import 'package:alexa_to_ai/services/ai_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// シングルトンインスタンスを提供するProvider
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});
