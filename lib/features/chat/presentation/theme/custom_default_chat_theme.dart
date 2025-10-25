import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class CustomDefaultChatTheme {
  DefaultChatTheme build() {
    return const DefaultChatTheme(
      inputBackgroundColor: Colors.blueAccent,
      primaryColor: Colors.blueAccent,
      userAvatarNameColors: [Colors.blueAccent],
    );
  }
}
