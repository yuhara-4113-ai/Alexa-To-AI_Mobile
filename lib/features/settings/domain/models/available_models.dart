import 'package:hive/hive.dart';

part 'available_models.g.dart';

/// Store for dynamically fetched AI models
@HiveType(typeId: 2)
class AvailableModels extends HiveObject {
  @HiveField(0)
  List<String> chatGPTModels;

  @HiveField(1)
  List<String> geminiModels;

  @HiveField(2)
  List<String> claudeModels;

  @HiveField(3)
  DateTime? lastUpdated;

  AvailableModels({
    List<String>? chatGPTModels,
    List<String>? geminiModels,
    List<String>? claudeModels,
    this.lastUpdated,
  })  : chatGPTModels = chatGPTModels ?? _getDefaultChatGPTModels(),
        geminiModels = geminiModels ?? _getDefaultGeminiModels(),
        claudeModels = claudeModels ?? _getDefaultClaudeModels();

  /// Get models for a specific AI type
  List<String> getModelsForType(String aiType) {
    switch (aiType) {
      case 'ChatGPT':
        return chatGPTModels;
      case 'Gemini':
        return geminiModels;
      case 'Claude':
        return claudeModels;
      default:
        return [];
    }
  }

  /// Check if a model exists for a given AI type
  bool hasModel(String aiType, String model) {
    return getModelsForType(aiType).contains(model);
  }

  /// Get the first model for a given AI type
  String getFirstModel(String aiType) {
    final models = getModelsForType(aiType);
    return models.isNotEmpty ? models[0] : '';
  }

  static List<String> _getDefaultChatGPTModels() {
    return [
      'chatgpt-4o-latest',
      'gpt-4o-mini',
      'o1-preview',
      'o1-mini',
      'gpt-4.5-preview',
    ];
  }

  static List<String> _getDefaultGeminiModels() {
    return [
      'gemini-1.5-pro-latest',
      'gemini-2.0-flash',
      'gemini-2.0-flash-exp',
      'gemini-2.0-flash-lite-preview',
      'gemini-2.0-flash-thinking-exp',
      'gemini-2.0-pro-exp',
    ];
  }

  static List<String> _getDefaultClaudeModels() {
    return [
      'claude-3-haiku-20240307',
      'claude-3-sonnet-20240229',
      'claude-3-opus-latest',
      'claude-3-5-haiku-latest',
      'claude-3-5-sonnet-latest',
      'claude-3-7-sonnet-20250219',
    ];
  }
}
