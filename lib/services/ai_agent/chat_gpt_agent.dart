import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/services/ai_agent/ai_agent.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

class ChatGPTAgent implements AIAgent {
  @override
  Future<String> sendMessage(String prompt, AIModel aiModel) async {
    setOpenAIClient(aiModel.apiKey);

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
      ],
      role: OpenAIChatMessageRole.user,
    );

    // これまでのやり取りを設定(今は単発)
    final requestMessages = [
      // systemMessage,
      userMessage,
    ];

    // OpenAIにリクエスト
    final respnse = await OpenAI.instance.chat.create(
      model: aiModel.model,
      messages: requestMessages,
      // TODO max_tokensはとりあえず固定値。後で設定画面から変更できるようにする
      maxTokens: 500,
      // AI回答のランダム性を持たせる場合は何かしらの数値を設定
      // AIの出力に一貫性を持たせるために使用される。seedを設定すると、AIは同じseed値を使用して同じプロンプトに対して同じレスポンスを生成します。
      // seedを設定しない場合や異なるseed値を使用すると、AIのレスポンスは異なる可能性がある。
      // TODO 設定画面から変更できるようにする
      seed: 6,
      // 生成されるテキストのランダム性と多様性を制御するためのパラメーター
      // temperatureは0から1までの値を取り、高い値はよりランダムなテキストを、低い値はより決定論的（予測可能）なテキストを生成します。
      // 具体的には、temperatureが1に近いと、AIは多様なレスポンスを生成し、それぞれの単語の選択肢をほぼ等しく考慮します。一方、temperatureが0に近いと、AIは最も確率的に高い単語を選択し、出力はより一貫性があります。
      // したがって、temperatureを調整することで、AIの出力の創造性と予測可能性のバランスを制御することができます。
      // TODO 設定画面から変更できるようにする
      temperature: 0.2,
    );

    // TODO 入出力のtoken(total_tokens)を保持し、このアプリでどのくらいのtoken数(料金)を消費しているかを表示したい
    debugPrint('totalTokens: ${respnse.usage.totalTokens.toString()}');
    String responseText = respnse.choices.first.message.content![0].text!;
    debugPrint('responseText: $responseText');
    return responseText;
  }

  void setOpenAIClient(String apiKey) {
    OpenAI.apiKey = apiKey;
    OpenAI.requestsTimeOut = const Duration(seconds: 60);
    // パッケージの操作ログを出力
    OpenAI.showLogs = true;
  }
}
