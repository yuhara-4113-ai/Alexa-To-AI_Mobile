import 'package:flutter/material.dart';

class HomeScreenButton extends StatelessWidget {
  final Widget screen;
  final String buttonText;

  const HomeScreenButton(
      {Key? key, required this.screen, required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // ボタンが押されたときに、引数の画面に遷移
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      // ボタンのラベル
      child: Text(buttonText),
    );
  }
}
