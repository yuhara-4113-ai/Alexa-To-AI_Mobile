import 'package:flutter/material.dart';

import 'package:alexa_to_ai/features/chat/presentation/pages/chat_ai_screen.dart';
import 'package:alexa_to_ai/features/settings/domain/models/setting_screen_model.dart';
import 'package:alexa_to_ai/features/settings/presentation/pages/setting_screen.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  FooterState createState() => FooterState();
}

class FooterState extends State<Footer> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    SettingScreen(
      settingScreenModel: SettingScreenModel(),
    ),
    const ChatAIScreen(),
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
    final bool isSelected = _currentIndex == index;
    final Color selectedColor = Colors.lightBlue.shade100;
    return Container(
      width: 100.0,
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : Colors.transparent,
        border: Border.all(
          color: isSelected ? selectedColor : Colors.transparent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Icon(iconData),
    );
  }
}
