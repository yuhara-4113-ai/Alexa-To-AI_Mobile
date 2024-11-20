import 'package:logger/logger.dart';
import 'package:openai_dart/openai_dart.dart';

import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/services/ai_agent/ai_agent.dart';

final log = Logger();

class ChatGPTAgent implements AIAgent {
  @override
  Future<String> sendMessage(final String prompt, AIModel aiModel) async {
    final client = OpenAIClient(apiKey: aiModel.apiKey);

    // OpenAIにリクエスト
    final response = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(aiModel.model),
        messages: [
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(prompt),
          ),
        ],
        // TODO maxCompletionTokensはとりあえず固定値。後で設定画面から変更できるようにする
        // 以下の場合はすいろんするため、通常のtokenより消費量があがる
        // 通常：160
        // o1-mini：500
        // o1-preview：1600
        maxCompletionTokens: 1000,
        // seedを設定してレスポンスの一貫性を保持（必要性があれば利用）
        seed: 6,
      ),
    );
    // ライブラリのExampleに書いてあったので一応endSessionしておく
    client.endSession();

    // TODO 入出力のtoken(total_tokens)を保持し、このアプリでどのくらいのtoken数(料金)を消費しているかを表示したい
    log.i('totalTokens: ${response.usage!.totalTokens.toString()}');

    String responseText = response.choices.first.message.content!;
    log.i('responseText: $responseText');

    return responseText;
  }
}
