// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

import '../models/env.dart';

class AIService {
  /// AIにリクエストを送信
  /// prompt: ユーザのチャット入力内容に「設定内容(キャラクター、口調など)」を付与した文字列
  Future<String> sendMessageToAi(String prompt) async {
    debugPrint('prompt=$prompt');

    // TODO 将来的にはAPIキーは設定画面で設定できるようにしたいが、一旦は.envから取得
    String apiKey = env[EnvKey.openApiKey]!;

    // OpenAIインスタンスの生成
    // 都度、生成するのは微妙だが、APIキーは変わる可能性があるため都度生成する
    final openAI = OpenAI.instance.build(
        token: apiKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
        enableLog: true);

    // role：contentの内容を送信する人（直前のやり取りも送信する場合はuser(人間)とsystem(ChatGPT)を設定する）
    // content：ChatGPTに送るプロンプト（指示）
    // max_tokens：ChatGPTが生成するテキストの最大トークン数
    // TODOO max_tokensはとりあえず固定値。後で設定画面から変更できるようにする
    final request = ChatCompleteText(messages: [
      Map.of({"role": Role.user.name, "content": prompt})
    ], maxToken: 500, model: GptTurboChatModel());

    // ChatGPTにリクエストを送信
    final response = await openAI.onChatCompletion(request: request);
    debugPrint('response!.toJson(): ${response!.toJson().toString()}');
    response.usage!.totalTokens;

    // TODO 入出力のtoken(total_tokens)を保持し、このアプリでどのくらいのtoken数(料金)を消費しているかを表示したい
    debugPrint('response.usage!.totalTokens: ${response.usage!.totalTokens}');

    String responseText = response.choices[0].message!.content;
    debugPrint('Response from GPT-3: $responseText');

    return responseText;
  }
}
