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

// 設定画面の状態を管理する StatefulWidget
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

    // 画面に表示する設定画面のmodelを取得
    _setViewnModel(settingScreenModelProvider);

    // 設定が保存されているかどうか(送信ボタンなどの活性/非活性を切り替える際に使用)
    ValueNotifier<bool> isCompareWithLocalDB =
        useState(settingScreenModelProvider.compareWithLocalDB());

    // 呼び名の入力フォームの状態を保持
    TextEditingController aiNameController = createAiNameController(
        settingScreenModelProvider, isCompareWithLocalDB);
    // 性格の選択状態を保持
    ValueNotifier<String> selectedAiPersonality = createSelectedAiPersonality(
        settingScreenModelProvider, isCompareWithLocalDB);
    // 口調の選択状態を保持
    ValueNotifier<String> selectedAiTone =
        createSelectedAiTone(settingScreenModelProvider, isCompareWithLocalDB);

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
            // 呼び名の入力フォーム
            TextField(
              controller: aiNameController, // 初期値
              decoration: const InputDecoration(labelText: 'キャラクター名'),
            ),
            // 性格の入力フォーム
            DropdownButtonFormField(
              value: selectedAiPersonality.value,
              // ドロップダウン項目の定義
              items: SettingScreenModel.aiPersonalityList
                  .map((label) => DropdownMenuItem(
                        value: label, // 各項目の値を設定します
                        child: Text(label), // 各項目のラベルを設定します
                      ))
                  .toList(), // ドロップダウンの項目をリストとして設定します
              onChanged: (value) {
                selectedAiPersonality.value = value!;
              },
              decoration:
                  const InputDecoration(labelText: '性格'), // フォームのラベルを設定します
            ),
            // 口調の入力フォーム
            DropdownButtonFormField(
              value: selectedAiTone.value,
              // ドロップダウン項目の定義
              items: SettingScreenModel.aiToneList
                  .map((label) => DropdownMenuItem(
                        value: label, // 各項目の値を設定します
                        child: Text(label), // 各項目のラベルを設定します
                      ))
                  .toList(), // ドロップダウンの項目をリストとして設定します
              onChanged: (value) {
                selectedAiTone.value = value!;
              },
              decoration:
                  const InputDecoration(labelText: '口調'), // フォームのラベルを設定します
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
          ],
        ),
      ),
    );
  }

  ValueNotifier<String> createSelectedAiTone(
      SettingScreenModel settingScreenModelProvider,
      ValueNotifier<bool> isCompareWithLocalDB) {
    final selectedAiTone = useState<String>(settingScreenModelProvider.aiTone);
    useEffect(() {
      selectedAiTone.addListener(() {
        settingScreenModelProvider.aiTone = selectedAiTone.value;
        // boxとの差分状態を更新
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      });
      // コンポーネントがアンマウントされるときにリスナーを削除します
      return () => selectedAiTone.removeListener(() {});
    }, []);
    return selectedAiTone;
  }

  ValueNotifier<String> createSelectedAiPersonality(
      SettingScreenModel settingScreenModelProvider,
      ValueNotifier<bool> isCompareWithLocalDB) {
    final selectedAiPersonality =
        useState<String>(settingScreenModelProvider.aiPersonality);
    useEffect(() {
      selectedAiPersonality.addListener(() {
        settingScreenModelProvider.aiPersonality = selectedAiPersonality.value;
        // boxとの差分状態を更新
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      });
      // コンポーネントがアンマウントされるときにリスナーを削除します
      return () => selectedAiPersonality.removeListener(() {});
    }, []);
    return selectedAiPersonality;
  }

  TextEditingController createAiNameController(
      SettingScreenModel settingScreenModelProvider,
      ValueNotifier<bool> isCompareWithLocalDB) {
    // TextEditingControllerのインスタンスを作成します
    final aiNameController = useTextEditingController();
    // 初期化時にテキストフィールドの初期値を設定します
    aiNameController.text = settingScreenModelProvider.aiName;
    // テキストフィールドの内容が変更されたときに呼び出されるリスナーを追加
    useEffect(() {
      aiNameController.addListener(() {
        // TODO 変更する度に状態保持に反映しており、無駄がある。フォーカスアウト時だけ検知できれば最低限の反映で済むが、実装が難しそうなので一旦このまま
        settingScreenModelProvider.aiName = aiNameController.text;
        // boxとの差分状態を更新
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      });
      // コンポーネントがアンマウントされるときにリスナーを削除します
      return () => aiNameController.removeListener(() {});
    }, []);
    return aiNameController;
  }

  /// 設定をローカルDBに保存
  Future<void> _saveSettings(SettingScreenModel model,
      ValueNotifier<bool> isCompareWithLocalDB) async {
    // TODO スナックバーで保存しましたを表示
    debugPrint(
        '保存しました: 名前=${model.aiName}, 性格=${model.aiPersonality}, 口調=${model.aiTone}');

    // 保存用のインスタンスを生成
    // 状態保持中のmodelをそのままboxに保存するとインスタンスが参照渡しになってしまい、差分が発生しなくなる
    SettingScreenModel saveData = SettingScreenModel()
      ..aiName = model.aiName
      ..aiPersonality = model.aiPersonality
      ..aiTone = model.aiTone;

    // ローカルDBに保存
    await settingModelBox.put(settingModelBoxKey, saveData);

    // TODO 以下のようにsave()でboxkeyを意識しないで保存できるようにしたい
    // model.save(){}

    // boxとの差分状態を更新
    isCompareWithLocalDB.value = model.compareWithLocalDB();

    // 設定内容をクラウド上に保存する関数を実行
    CloudStorageService().saveAISettingData(model);
  }

  /// ローカルDBに保存されている設定がある場合は、状態保持中のmodelに設定を反映
  void _setViewnModel(SettingScreenModel settingScreenModelProvider) {
    final settingModel = settingModelBox.get(settingModelBoxKey);

    // TODO 状態保持中のmodelが空の判定をどうするか。とりあえずは名前が空で判定している
    // ローカルDBが保存済みかつ、「状態保持中のmodel」が空の場合は、ローカルDBの設定を状態保持中のmodelに反映
    if ((settingModel != null) && (settingScreenModelProvider.aiName.isEmpty)) {
      debugPrint('ローカルDBの設定を状態保持中のmodelに反映');
      debugPrint('box: ${settingModel.toString()}');
      debugPrint('this: ${settingScreenModelProvider.toString()}');

      settingScreenModelProvider
        ..aiName = settingModel.aiName
        ..aiPersonality = settingModel.aiPersonality
        ..aiTone = settingModel.aiTone;
    }
  }
}
