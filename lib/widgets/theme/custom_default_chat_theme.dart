import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class CustomDefaultChatTheme {
  DefaultChatTheme build() {
    return const DefaultChatTheme(
      inputBackgroundColor: Colors.blueAccent, // メッセージ入力欄の背景色
      primaryColor: Color.fromARGB(255, 242, 242, 242), // メッセージの背景色
      userAvatarNameColors: [Colors.blueAccent], // ユーザー名の文字色
    );
  }
}
