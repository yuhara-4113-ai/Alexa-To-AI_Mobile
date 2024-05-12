import 'package:alexa_to_ai/models/setting_screen_model.dart';
import 'package:alexa_to_ai/views/chat_ai_screen.dart';
import 'package:alexa_to_ai/views/setting_screen.dart';
import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  FooterState createState() => FooterState();
}

class FooterState extends State<Footer> {
  // デフォルトはホーム画面
  int _currentIndex = 0;

  // フッターのアイコンをタップしたときに遷移する画面
  // この配列の順番(index)とcurrentIndexが連動している
  final List<Widget> _children = [
    // デフォルト
    SettingScreen(
      settingScreenModel: SettingScreenModel(),
    ),
    const ChatAIScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
