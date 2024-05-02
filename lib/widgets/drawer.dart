// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  // 動的なDrawerのListTile部分を受け取るためのプロパティ
  final List<Widget> tiles;

  const CustomDrawer({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'メニュー',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ...tiles, // 引数として受け取ったListTileのリストを配置
        ],
      ),
    );
  }
}
