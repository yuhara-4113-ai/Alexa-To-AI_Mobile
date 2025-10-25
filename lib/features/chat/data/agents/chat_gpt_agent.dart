import 'package:logger/logger.dart';
import 'package:openai_dart/openai_dart.dart';

import 'package:alexa_to_ai/features/chat/data/agents/ai_agent.dart';
import 'package:alexa_to_ai/features/settings/domain/models/ai_model.dart';

final log = Logger();

class ChatGPTAgent implements AIAgent {
  @override
  Future<String> sendMessage(final String prompt, AIModel aiModel) async {
    final client = OpenAIClient(apiKey: aiModel.apiKey);

    final response = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(aiModel.model),
        messages: [
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(prompt),
          ),
        ],
        maxCompletionTokens: 1000,
        seed: 6,
      ),
    );
    client.endSession();

    log.i('totalTokens: ${response.usage!.totalTokens.toString()}');

    final String responseText = response.choices.first.message.content!;
    log.i('responseText: $responseText');

    return responseText;
  }
}
