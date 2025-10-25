import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alexa_to_ai/features/chat/data/services/ai_service.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});
