import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class CustomDarkChatTheme {
  DarkChatTheme build() {
    return DarkChatTheme(
      inputBackgroundColor: Colors.black, // メッセージ入力欄の背景色
      // TODO ダークテーマでフッターと色が被ってる件の修正方法の1つ(フッターの上部だけに色がつけれたらベスト)
      inputContainerDecoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(20),
      ),
      userAvatarNameColors: const [Colors.white70],
      backgroundColor: Colors.grey[850]!,
    );
  }
}
