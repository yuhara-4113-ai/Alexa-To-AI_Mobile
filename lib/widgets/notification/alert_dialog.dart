import 'package:flutter/material.dart';

/// アラートダイアログのカスタムウィジェット
/// デフォルトより以下のサイズを大きくしている
/// ・メッセージ
/// ・ボタン名
class CustomAlertDialog extends StatelessWidget {
  final String titleValue;
  final String contentValue;
  final VoidCallback onOkPressed;

  const CustomAlertDialog({
    super.key,
    required this.titleValue,
    required this.contentValue,
    required this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleValue),
      content: Text(
        contentValue,
        style: const TextStyle(fontSize: 20.0),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onOkPressed,
          child: const Text(
            'OK',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ],
    );
  }
}
