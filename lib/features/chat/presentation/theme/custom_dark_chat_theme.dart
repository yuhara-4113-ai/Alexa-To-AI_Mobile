import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class CustomDarkChatTheme {
  DarkChatTheme build() {
    return DarkChatTheme(
      inputBackgroundColor: Colors.black,
      inputContainerDecoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(20),
      ),
      userAvatarNameColors: const [Colors.white70],
      backgroundColor: Colors.grey.shade800,
    );
  }
}
