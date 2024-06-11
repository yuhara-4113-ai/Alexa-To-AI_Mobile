import 'dart:developer';

import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/services/ai_agent/ai_agent.dart';
import 'package:dart_openai/dart_openai.dart';

class ChatGPTAgent implements AIAgent {
  @override
  Future<String> sendMessage(String prompt, AIModel aiModel) async {
    setOpenAIClient(aiModel.apiKey);

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)],
      role: OpenAIChatMessageRole.user,
    );

    // これまでのやり取りを設定 (今は単発)
    final requestMessages = [
      userMessage,
    ];

    // OpenAIにリクエスト
    final response = await OpenAI.instance.chat.create(
      model: aiModel.model,
      messages: requestMessages,
      // TODO max_tokensはとりあえず固定値。後で設定画面から変更できるようにする
      maxTokens: 500,
      // 生成されるテキストのランダム性と多様性を制御
      // temperatureが1に近いと、AIは多様なレスポンスを生成し、それぞれの単語の選択肢をほぼ等しく考慮します。
      // 一方、temperatureが0に近いと、AIは最も確率的に高い単語を選択し、出力はより一貫性があります。
      // TODO とりあえず固定値。設定画面から変更できるようにする
      temperature: 0.2,
      // seedを設定してレスポンスの一貫性を保持（必要性があれば利用）
      seed: 6,
    );

    // TODO 入出力のtoken(total_tokens)を保持し、このアプリでどのくらいのtoken数(料金)を消費しているかを表示したい
    log('totalTokens: ${response.usage.totalTokens.toString()}');

    String responseText = response.choices.first.message.content![0].text!;
    log('responseText: $responseText');
    return responseText;
  }

  void setOpenAIClient(String apiKey) {
    OpenAI.apiKey = apiKey;
    OpenAI.requestsTimeOut = const Duration(seconds: 60);
    // パッケージの操作ログを出力
    OpenAI.showLogs = true;
  }
}
