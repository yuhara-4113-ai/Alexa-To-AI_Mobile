// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

/// AIにリクエストを送信
/// prompt: ユーザのチャット入力内容に「設定内容(キャラクター、口調など)」を付与した文字列
Future<String> sendMessageToAi(String prompt) async {
  debugPrint('prompt=$prompt');

  // TODO APIキーは設定画面で設定できるようにしてからコミットする
  String apiKey = 'test';

  // OpenAIインスタンスの生成
  // 都度、生成するのは微妙だが、APIキーは変わる可能性があるため都度生成する
  final openAI = OpenAI.instance.build(
      token: apiKey,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
      enableLog: true);

  // role：GPT-3に送るメッセージの役割（ユーザ、システム、アシスタントなど）
  // content：GPT-3に送るプロンプト（指示）
  // max_tokens：GPT-3が生成するテキストの最大トークン数
  // TODOO max_tokensはとりあえず固定値。後で設定画面から変更できるようにする
  final request = ChatCompleteText(messages: [
    Map.of({"role": Role.user.name, "content": prompt})
  ], maxToken: 500, model: GptTurboChatModel());

  final response = await openAI.onChatCompletion(request: request);
  // String responseText =
  //     response!.choices.map((e) => e.message?.content).toString();
  String responseText = response!.choices[0].message!.content;
  debugPrint('Response from GPT-3: $responseText');

  return responseText;
}
