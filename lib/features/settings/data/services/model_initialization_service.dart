import 'package:logger/logger.dart';
import 'package:alexa_to_ai/features/settings/data/local/settings_hive_box.dart';
import 'package:alexa_to_ai/features/settings/data/services/model_fetcher_service.dart';
import 'package:alexa_to_ai/features/settings/domain/models/available_models.dart';
import 'package:alexa_to_ai/features/settings/domain/models/setting_screen_model.dart';
import 'package:alexa_to_ai/features/settings/domain/models/ai_model.dart';

final log = Logger();

/// Service to initialize AI models at app startup
class ModelInitializationService {
  final ModelFetcherService _modelFetcher = ModelFetcherService();

  /// Initialize models at app startup
  /// Returns true if a model was reset (to show warning to user)
  Future<bool> initializeModels() async {
    bool modelWasReset = false;

    try {
      // Get current settings
      final settingModel = settingModelBox.get(settingModelBoxKey);
      if (settingModel == null) {
        log.w('Settings model not found');
        return false;
      }

      // Get available models from storage
      AvailableModels? availableModels =
          availableModelsBox.get(availableModelsBoxKey);

      if (availableModels == null) {
        availableModels = AvailableModels();
        await availableModelsBox.put(availableModelsBoxKey, availableModels);
      }

      // Try to fetch new models for each AI type
      await _fetchAndUpdateModels(settingModel, availableModels);

      // Validate current selected model
      modelWasReset = await _validateAndFixModels(settingModel, availableModels);

      // Save updated available models
      await availableModelsBox.put(availableModelsBoxKey, availableModels);

      log.i('Model initialization completed. Model reset: $modelWasReset');
    } catch (e) {
      log.e('Error during model initialization: $e');
    }

    return modelWasReset;
  }

  /// Fetch and update models from APIs
  Future<void> _fetchAndUpdateModels(
    SettingScreenModel settingModel,
    AvailableModels availableModels,
  ) async {
    // Fetch ChatGPT models
    try {
      final chatGPTApiKey =
          settingModel.aiModelsPerType[AITypes.chatGPT.name]?.apiKey ?? '';
      final chatGPTModels =
          await _modelFetcher.fetchChatGPTModels(chatGPTApiKey);
      if (chatGPTModels.isNotEmpty) {
        availableModels.chatGPTModels = chatGPTModels;
        log.i('Updated ChatGPT models: ${chatGPTModels.length} models');
      }
    } catch (e) {
      log.e('Failed to fetch ChatGPT models: $e');
    }

    // Fetch Gemini models
    try {
      final geminiApiKey =
          settingModel.aiModelsPerType[AITypes.gemini.name]?.apiKey ?? '';
      final geminiModels = await _modelFetcher.fetchGeminiModels(geminiApiKey);
      if (geminiModels.isNotEmpty) {
        availableModels.geminiModels = geminiModels;
        log.i('Updated Gemini models: ${geminiModels.length} models');
      }
    } catch (e) {
      log.e('Failed to fetch Gemini models: $e');
    }

    // Fetch Claude models
    try {
      final claudeApiKey =
          settingModel.aiModelsPerType[AITypes.claude.name]?.apiKey ?? '';
      final claudeModels = await _modelFetcher.fetchClaudeModels(claudeApiKey);
      if (claudeModels.isNotEmpty) {
        availableModels.claudeModels = claudeModels;
        log.i('Updated Claude models: ${claudeModels.length} models');
      }
    } catch (e) {
      log.e('Failed to fetch Claude models: $e');
    }

    availableModels.lastUpdated = DateTime.now();
  }

  /// Validate saved models and fix if necessary
  /// Returns true if any model was reset
  Future<bool> _validateAndFixModels(
    SettingScreenModel settingModel,
    AvailableModels availableModels,
  ) async {
    bool modelWasReset = false;

    // Check each AI type
    for (final aiType in AITypes.values) {
      final aiModel = settingModel.aiModelsPerType[aiType.name];
      if (aiModel != null) {
        final currentModel = aiModel.model;
        final availableModelsList = availableModels.getModelsForType(aiType.name);

        // Check if current model exists in available models
        if (!availableModelsList.contains(currentModel)) {
          log.w(
            'Model "$currentModel" not found for ${aiType.name}. Resetting to first available model.',
          );
          
          // Reset to first available model
          if (availableModelsList.isNotEmpty) {
            aiModel.model = availableModelsList[0];
            modelWasReset = true;
            
            log.i('Reset ${aiType.name} model to: ${aiModel.model}');
          }
        }
      }
    }

    // Save changes if any model was reset
    if (modelWasReset) {
      await settingModelBox.put(settingModelBoxKey, settingModel);
    }

    return modelWasReset;
  }

  /// Get available models for a specific AI type
  List<String> getAvailableModels(String aiType) {
    final availableModels = availableModelsBox.get(availableModelsBoxKey);
    if (availableModels == null) {
      log.w('Available models not found, returning empty list');
      return [];
    }
    return availableModels.getModelsForType(aiType);
  }
}
