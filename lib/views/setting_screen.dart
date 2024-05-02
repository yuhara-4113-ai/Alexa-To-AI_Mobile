// 必要なパッケージとファイルをインポート
import 'package:flutter/material.dart'; // Flutterのマテリアルデザインパッケージ
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/database.dart';
import '../models/setting_screen_model.dart';
import '../providers/setting_screen_model_provider.dart';
import '../services/cloud_storage_service.dart';
import '../widgets/drawer.dart';

import 'home_screen.dart';
import 'chat_ai_screen.dart';

final cloudStorageService = CloudStorageService();

class SettingScreen extends HookConsumerWidget {
  // コンストラクタ 状態を保持しているModelを受け取る
  final SettingScreenModel settingScreenModel;
  const SettingScreen({Key? key, required this.settingScreenModel})
      : super(key: key);

  // 画面名
  static String name = '設定画面';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態保持している設定画面のmodelを取得
    final settingScreenModelProvider = ref.watch(settingScreenModelState);

    // 画面描画後に1度だけ呼び出されるメソッド
    useEffect(() {
      // 画面に表示する設定画面のmodelを取得
      _setViewnModel(settingScreenModelProvider);
      return () {
        // このコードはウィジェットが破棄されるときに実行されます
        // disposeのような動作を行います
      };
    }, const []);

    // 設定が保存されているかどうか(送信ボタンなどの活性/非活性を切り替える際に使用)
    ValueNotifier<bool> isCompareWithLocalDB =
        useState(settingScreenModelProvider.compareWithLocalDB());

    // 呼び名の入力フォームの状態を保持
    TextEditingController aiToneController = createAiToneController(
        settingScreenModelProvider, isCompareWithLocalDB);

    // Scaffoldを使用して基本的なレイアウトを作成
    return Scaffold(
      appBar: AppBar(
        title: Text(name), // アプリバーのタイトル
      ),
      drawer: CustomDrawer(
        // TODO 今はtilesを各画面でコピペで定義している状態。各画面で自画面は非表示にできたら、シンプルにできる
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
            title: Text(ChatAIScreen.name),
            onTap: () {
              // AIチャット画面への遷移
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ChatAIScreen()),
              );
            },
          ),
        ],
      ),
      // 画面の主要な部分
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // フォームの項目(定義順に縦に並べる)
          children: [
            // 口調/キャラクター名の入力フォーム
            TextField(
              // TODO TextFieldの入力中に画面描画が行われると、フォーカスが失われるため、キーボードの予測変換が閉じてしまう
              // 上記の解消：keyを定義し、TextFieldの状態を保持する
              // ⇨ダメだった
              key: const Key('aiToneTextFieldKey'),
              controller: aiToneController, // 初期値
              decoration: const InputDecoration(labelText: '口調/キャラクター名'),
            ),
            // 保存ボタン
            const SizedBox(height: 20), // フォームとボタンの間にスペースを作成します
            ElevatedButton(
              onPressed: isCompareWithLocalDB.value
                  // 活性
                  ? () {
                      _saveSettings(
                          settingScreenModelProvider, isCompareWithLocalDB);
                    }
                  // 非活性
                  : null,
              child: Text(
                isCompareWithLocalDB.value ? '変更内容を保存' : '設定に変更はありません',
              ),
            ),
            // チャット画面への遷移ボタン
            const SizedBox(height: 20), // フォームとボタンの間にスペースを作成します
            ElevatedButton(
              onPressed: () {
                // AIチャット画面への遷移
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatAIScreen()),
                );
              },
              child: const Text(
                'AIチャット画面でお試し',
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController createAiToneController(
      SettingScreenModel settingScreenModelProvider,
      ValueNotifier<bool> isCompareWithLocalDB) {
    // TextEditingControllerのインスタンスを作成します
    final aiToneController = useTextEditingController();
    // 初期化時にテキストフィールドの初期値を設定します
    aiToneController.text = settingScreenModelProvider.aiTone;

    // テキストフィールドの内容が変更されたときに呼び出されるリスナーを追加
    useEffect(() {
      aiToneController.addListener(() {
        // TODO 変更する度に状態保持に反映しており、無駄がある。フォーカスアウト時だけ検知できれば最低限の反映で済むが、実装が難しそうなので一旦このまま
        // TODO 上記の影響もあり、「保存ボタン」のstaetが変更した直後、1文字目の入力後が確定したような挙動になり、予測バーみたいのが閉じてしまう
        settingScreenModelProvider.aiTone = aiToneController.text;
        // boxとの差分状態を更新
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      });
      // コンポーネントがアンマウントされるときにリスナーを削除します
      return () => aiToneController.removeListener(() {});
    }, []);
    return aiToneController;
  }

  /// 設定をローカルDBに保存
  Future<void> _saveSettings(SettingScreenModel model,
      ValueNotifier<bool> isCompareWithLocalDB) async {
    // TODO スナックバーで保存しましたを表示
    debugPrint('保存しました: 名前=${model.aiTone}');

    // 保存用のインスタンスを生成
    // 状態保持中のmodelをそのままboxに保存するとインスタンスが参照渡しになってしまい、差分が発生しなくなる
    SettingScreenModel saveData = SettingScreenModel()
      ..aiTone = model.aiTone
      ..isSaved = true;

    // ローカルDBに保存
    await settingModelBox.put(settingModelBoxKey, saveData);

    // TODO 以下のようにsave()でboxkeyを意識しないで保存できるようにしたい
    // model.save(){}

    // boxとの差分状態を更新
    isCompareWithLocalDB.value = model.compareWithLocalDB();

    // 設定内容をクラウド上に保存する関数を実行
    cloudStorageService.saveAISettingData(model);
  }

  /// ローカルDBに保存されている設定がある場合は、状態保持中のmodelに設定を反映
  void _setViewnModel(SettingScreenModel settingScreenModelProvider) {
    final settingModel = settingModelBox.get(settingModelBoxKey);
    debugPrint('ローカルDBの設定を状態保持中のmodelに反映');
    debugPrint('box: ${settingModel.toString()}');
    debugPrint('this: ${settingScreenModelProvider.toString()}');

    settingScreenModelProvider.aiTone = settingModel!.aiTone;
  }
}
