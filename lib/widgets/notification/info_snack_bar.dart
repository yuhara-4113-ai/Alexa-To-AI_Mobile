import 'package:flutter/material.dart';

class InfoSnackBar {
  final String contentText;
  final BuildContext context;

  const InfoSnackBar({
    required this.contentText,
    required this.context,
  });

  SnackBar build() {
    return SnackBar(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0), // 上下の余白を設定
        child: Text(
          contentText,
          style: const TextStyle(fontSize: 14.0),
        ),
      ),
      backgroundColor: Colors.green[400], // スナックバーの背景色を緑に設定
      behavior: SnackBarBehavior.floating, // スナックバーを浮かせる
      // 角丸の半径を設定
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(milliseconds: 900), // 表示時間
      action: SnackBarAction(
        // label(右端に表示する文字)は表示したくないが、必須のため空文字を設定
        label: '',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
