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
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.settings, 0),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.chat, 1),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    bool isSelected = _currentIndex == index;
    Color selectedColor = Colors.lightBlue.shade100;
    return Container(
      width: 100.0, // 枠線の横幅
      padding: const EdgeInsets.all(2.0), // アイコンと枠線の余白
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : Colors.transparent, // 枠線内の背景色
        border: Border.all(
          color: _currentIndex == index ? selectedColor : Colors.transparent,
          width: 2.0, // 枠線の太さ
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Icon(iconData),
    );
  }
}
