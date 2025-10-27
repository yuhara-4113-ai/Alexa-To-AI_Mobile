import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final log = Logger();

/// Service to fetch available AI models from various providers
class ModelFetcherService {
  /// Fetch available ChatGPT models from OpenAI API
  /// Returns only chat-compatible famous models
  Future<List<String>> fetchChatGPTModels(String apiKey) async {
    try {
      if (apiKey.isEmpty) {
        log.w('ChatGPT API key is empty, using default models');
        return _getDefaultChatGPTModels();
      }

      final client = OpenAIClient(apiKey: apiKey);
      final response = await client.listModels();
      client.endSession();

      // Filter for chat models and famous ones
      // Note: Includes vision/multimodal models as they are chat-compatible
      final chatModels = response.data
          .where((model) {
            final id = model.id.toLowerCase();
            return (id.contains('gpt-4') ||
                    id.contains('gpt-3.5') ||
                    id.contains('o1') ||
                    id.contains('chatgpt')) &&
                !id.contains('instruct');
          })
          .map((model) => model.id)
          .toList();

      // Sort to prioritize newer models
      chatModels.sort((a, b) => b.compareTo(a));

      if (chatModels.isEmpty) {
        log.w('No chat models found, using default models');
        return _getDefaultChatGPTModels();
      }

      log.i('Fetched ${chatModels.length} ChatGPT models');
      return chatModels;
    } catch (e) {
      log.e('Failed to fetch ChatGPT models: $e');
      return _getDefaultChatGPTModels();
    }
  }

  /// Fetch available Gemini models from Google AI API
  /// Returns only chat-compatible famous models
  Future<List<String>> fetchGeminiModels(String apiKey) async {
    try {
      if (apiKey.isEmpty) {
        log.w('Gemini API key is empty, using default models');
        return _getDefaultGeminiModels();
      }

      final url = Uri.https(
        'generativelanguage.googleapis.com',
        '/v1beta/models',
        {'key': apiKey},
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = (data['models'] as List)
            .where((model) {
              final name = (model['name'] as String).toLowerCase();
              // Filter for chat-compatible famous models
              // Note: Includes vision/multimodal models as they support chat functionality
              return name.contains('gemini') &&
                  (name.contains('pro') ||
                      name.contains('flash') ||
                      name.contains('mini') ||
                      name.contains('lite'));
            })
            .map((model) {
              // Extract model ID from the full name
              final fullName = model['name'] as String;
              return fullName.split('/').last;
            })
            .toList();

        if (models.isEmpty) {
          log.w('No Gemini models found, using default models');
          return _getDefaultGeminiModels();
        }

        log.i('Fetched ${models.length} Gemini models');
        return models;
      } else {
        log.e('Failed to fetch Gemini models: ${response.statusCode}');
        return _getDefaultGeminiModels();
      }
    } catch (e) {
      log.e('Failed to fetch Gemini models: $e');
      return _getDefaultGeminiModels();
    }
  }

  /// Fetch available Claude models from Anthropic API
  /// Since Anthropic doesn't provide a models list API, use hardcoded famous models
  Future<List<String>> fetchClaudeModels(String apiKey) async {
    // Anthropic doesn't have a public API to list models
    // Return the known famous Claude models
    return _getDefaultClaudeModels();
  }

  /// Default ChatGPT models (famous chat models)
  List<String> _getDefaultChatGPTModels() {
    return [
      'chatgpt-4o-latest',
      'gpt-4o-mini',
      'o1-preview',
      'o1-mini',
      'gpt-4.5-preview',
    ];
  }

  /// Default Gemini models (famous chat models)
  List<String> _getDefaultGeminiModels() {
    return [
      'gemini-1.5-pro-latest',
      'gemini-2.0-flash',
      'gemini-2.0-flash-exp',
      'gemini-2.0-flash-lite-preview',
      'gemini-2.0-flash-thinking-exp',
      'gemini-2.0-pro-exp',
    ];
  }

  /// Default Claude models (famous chat models)
  List<String> _getDefaultClaudeModels() {
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
