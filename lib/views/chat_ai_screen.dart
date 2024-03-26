// Flutterとその他のパッケージをインポート
import 'package:flutter/material.dart';

import '../database/database.dart';
import '../models/setting_screen_model.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/drawer.dart';

import 'home_screen.dart';
import 'setting_screen.dart';

// 設定画面で保存した内容をローカルDBから取得
final settingModel = settingModelBox.get(settingModelBoxKey);

// ChatAIScreenという名前のStatefulWidgetを作成
class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  // 画面名
  static String name = 'AIチャット画面';

  @override
  ChatAIScreenState createState() => ChatAIScreenState();
}

// ChatAIScreenの状態を管理するクラス
class ChatAIScreenState extends State<ChatAIScreen> {
  List<String> messages = []; // メッセージを格納するリスト
  TextEditingController messageController =
      TextEditingController(); // メッセージ入力のコントローラー
  bool _isSettingSaved = true; // 設定が保存されているかどうか(送信ボタンなどの活性/非活性を切り替える際に使用)

  @override
  // 画面描画後に呼び出されるメソッド
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ローカルDBに設定情報がない場合(初期インストール後に設定画面で保存してない場合など)
      // アラートを表示し、対象の画面要素を非活性(再描画)にする
      final settingModel = settingModelBox.get(settingModelBoxKey);
      if (settingModel == null) {
        _showAlertDialog();
        setState(() {
          _isSettingSaved = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ChatAIScreen.name), // アプリバーのタイトル
      ),
      // ハンバーガーメニュー
      drawer: CustomDrawer(
        // todo 今はtilesを各画面でコピペで定義している状態。各画面で自画面は非表示にできたら、シンプルにできる
        tiles: [
          ListTile(
            title: Text(HomeScreen.name),
            onTap: () {
              // ホーム画面への遷移
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            title: Text(SettingScreen.name),
            onTap: () {
              // 設定画面への遷移
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingScreen(
                        settingScreenModel: SettingScreenModel())),
              );
            },
          ),
        ],
      ),
      // 画面の主要な部分
      body: Column(
        children: <Widget>[
          // メッセージの履歴
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // メッセージを表示するリストタイルを作成
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 70.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController, // テキストフィールドのコントローラー
                    decoration: const InputDecoration(
                      hintText: 'メッセージを入力', // ヒントテキスト
                    ),
                    enabled: _isSettingSaved,
                  ),
                ),
                // 送信ボタン
                Material(
                  child: Center(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.blue,
                        shape: CircleBorder(),
                      ),
                      // 送信ボタン(本体)
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: _isSettingSaved
                            // 活性
                            ? () {
                                _onPressedSendButton();
                              }
                            // 非活性
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 送信ボタンが押された際の処理
  void _onPressedSendButton() {
    // メッセージが空でない場合に送信処理を行う
    if (messageController.text.isNotEmpty) {
      // メッセージをAIに送信
      _sendMessageToAi(messageController.text);
      // 画面再描画
      setState(() {
        // 入力されたメッセージをリストに追加(チャット履歴として表示)
        messages.add(messageController.text);
        // メッセージ入力欄をクリア
        messageController.clear();
      });
    }
  }

  /// 設定が未保存の場合にアラートを表示
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          titleValue: '設定が未保存です',
          contentValue: '設定画面で保存した後にメッセージの送信が行えます',
          onOkPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  /// `_sendMessage`メソッドは、ユーザの入力文字列をAIに送信
  void _sendMessageToAi(String message) async {
    debugPrint('送信しました: 名前=$message');

    if (settingModel == null) {
      return;
    } else {
      debugPrint('settingModel=$settingModel.toString()');
    }

    // ここでai_service.dartのsendMessageToAiを呼び出す
  }
}
