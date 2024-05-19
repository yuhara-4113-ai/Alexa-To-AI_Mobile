import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class CustomDarkChatTheme {
  DarkChatTheme build() {
    return DarkChatTheme(
      inputBackgroundColor: Colors.black, // メッセージ入力欄の背景色
      userAvatarNameColors: const [Colors.white70],
      backgroundColor: Colors.grey[850]!,
    );
  }
}
