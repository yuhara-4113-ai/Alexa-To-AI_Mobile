// 必要なパッケージとファイルをインポート
import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Flutterのマテリアルデザインパッケージ
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:alexa_to_ai/database/database.dart';
import 'package:alexa_to_ai/models/setting_screen_model.dart';
import 'package:alexa_to_ai/providers/setting_screen_model_provider.dart';
import 'package:alexa_to_ai/services/cloud_storage_service.dart';
import 'package:alexa_to_ai/widgets/alert_dialog.dart';
import 'package:alexa_to_ai/widgets/drawer.dart';

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

    // 口調の入力フォームの状態を保持
    TextEditingController aiToneController = createAiToneController(
        settingScreenModelProvider, isCompareWithLocalDB);

    // apiKeyの入力フォームの状態を保持
    TextEditingController apiKeyController = createApiKeyController(
        settingScreenModelProvider, isCompareWithLocalDB);

    // AIの種別(ChatGPT、Geminiなど)
    ValueNotifier<String> selectedModel =
        useState<String>(settingScreenModelProvider.getAIModel().model);
    // 監視対象が変更されたときに呼び出されるリスナーを追加
    useEffect(() {
      selectedModel.addListener(() {
        settingScreenModelProvider.getAIModel().model = selectedModel.value;
        // boxとの差分状態を更新
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      });
      // コンポーネントがアンマウントされるときにリスナーを削除します
      return () => selectedModel.removeListener(() {});
    }, []);

    // AIの種別(ChatGPT、Geminiなど)
    ValueNotifier<String> selectedType =
        useState<String>(settingScreenModelProvider.selectedType);
    // テキストフィールドの内容が変更されたときに呼び出されるリスナーを追加
    useEffect(() {
      selectedType.addListener(() {
        settingScreenModelProvider.selectedType = selectedType.value;
        // 連動するAIのモデル(プルダウン)も該当のモデルで更新
        selectedModel.value = settingScreenModelProvider.getAIModel().model;
        // boxとの差分状態を更新
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      });
      // コンポーネントがアンマウントされるときにリスナーを削除します
      return () => selectedType.removeListener(() {});
    }, []);

    // APIキーの表示/非表示を切り替えるための状態を保持(画面初期表示時は非表示)
    ValueNotifier<bool> apiKeyObscureStatus = useState<bool>(true);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // フォームの項目(定義順に縦に並べる)
          children: [
            const Text(
              'AIのレスポンス',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // 口調/キャラクター名の入力フォーム
            TextField(
              // TODO TextFieldの入力中に画面描画が行われると、フォーカスが失われるため、キーボードの予測変換が閉じてしまう
              // 上記の解消：keyを定義し、TextFieldの状態を保持する
              // ⇨ダメだった
              key: const Key('aiToneTextFieldKey'),
              controller: aiToneController, // 初期値
              decoration: const InputDecoration(labelText: '口調/キャラクター名'),
            ),
            const SizedBox(height: 30), // フォームとボタンの間にスペースを作成します
            const Text(
              '使用するAI',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedType.value,
              items:
                  aiType.values.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                selectedType.value = newValue!;
              },
            ),
            TextFormField(
              // 値を管理(初期値、変更)するcontroller
              controller: apiKeyController,
              // APIキーの表示/非表示
              obscureText: apiKeyObscureStatus.value,
              decoration: InputDecoration(
                labelText: 'APIキー',
                // APIキーの入力内容は表示/非表示を切り替えられるようにする
                suffixIcon: IconButton(
                  icon: Icon(
                    // _obscureTextの値に応じてアイコンを切り替える
                    apiKeyObscureStatus.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    // _obscureTextの値を反転
                    apiKeyObscureStatus.value = !apiKeyObscureStatus.value;
                  },
                ),
              ),
            ),
            FormField(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'モデル',
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedModel.value,
                      items: modelConfig[settingScreenModelProvider
                              .getKeyFromSelectedType()]!
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedModel.value = newValue!;
                      },
                    ),
                  ),
                );
              },
            ),
            // 保存ボタン
            const SizedBox(height: 20), // フォームとボタンの間にスペースを作成します
            ElevatedButton(
              onPressed: isCompareWithLocalDB.value
                  // 活性
                  ? () {
                      _saveSettings(settingScreenModelProvider,
                          isCompareWithLocalDB, context);
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

  DropdownMenuItem<AITypes> buildDropdownMenuItem(AITypes aiType) {
    return DropdownMenuItem<AITypes>(
      value: aiType,
      child: Text(aiType.toString().split('.').last),
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

  TextEditingController createApiKeyController(
      SettingScreenModel settingScreenModelProvider,
      ValueNotifier<bool> isCompareWithLocalDB) {
    // TextEditingControllerのインスタンスを作成します
    final apiKeyController = useTextEditingController();

    // 初期化時にテキストフィールドの初期値を設定します
    AIModel aiModel = settingScreenModelProvider.getAIModel();
    apiKeyController.text = aiModel.apiKey;

    // テキストフィールドの内容が変更されたときに呼び出されるリスナーを追加
    useEffect(() {
      apiKeyController.addListener(() {
        // 現在のAI種別に対応するAPIキーを更新するため、都度取得する
        AIModel aiModel = settingScreenModelProvider.getAIModel();
        aiModel.apiKey = apiKeyController.text;

        // boxとの差分状態を更新
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      });
      // コンポーネントがアンマウントされるときにリスナーを削除します
      return () => apiKeyController.removeListener(() {});
    }, []);
    return apiKeyController;
  }

  /// 設定をローカルDBに保存
  Future<void> _saveSettings(SettingScreenModel model,
      ValueNotifier<bool> isCompareWithLocalDB, BuildContext context) async {
    // 保存用のインスタンスを生成
    // 状態保持中のmodelをそのままboxに保存するとインスタンスが共有されてしまい、差分が発生しなくなる
    SettingScreenModel saveData = SettingScreenModel()
      ..aiTone = model.aiTone
      ..isSaved = true
      ..selectedType = model.selectedType
      ..aiModelsPerType = model.copyApiKeyForType();

    // ローカルDBに保存
    await settingModelBox.put(settingModelBoxKey, saveData);

    debugPrint('_saveSettings box: ${saveData.toJson()}');

    // boxとの差分状態を更新
    isCompareWithLocalDB.value = model.compareWithLocalDB();

    // 設定内容をクラウド上に保存する関数を実行
    // 結果を画面に表示
    cloudStorageService.saveAISettingData(model).then((success) {
      if (success) {
        _showSnackBar(context);
      } else {
        _showAlertDialog(context);
      }
    }).catchError((error) {
      debugPrint(error);
      _showAlertDialog(context);
    });
  }

  /// ローカルDBに保存されている設定がある場合は、状態保持中のmodelに設定を反映
  void _setViewnModel(SettingScreenModel settingScreenModelProvider) {
    final settingModel = settingModelBox.get(settingModelBoxKey);
    debugPrint('ローカルDBの設定を状態保持中のmodelに反映');
    debugPrint('_setViewnModel box: ${settingModel?.toJson()}');
    debugPrint('_setViewnModel this: ${settingScreenModelProvider.toJson()}');

    settingScreenModelProvider.aiTone = settingModel!.aiTone;
    settingScreenModelProvider.selectedType = settingModel.selectedType;
    settingScreenModelProvider.aiModelsPerType =
        settingModel.copyApiKeyForType();
  }

  /// 保存に失敗した場合にアラートを表示
  void _showSnackBar(context) {
    SnackBar snackBar = SnackBar(
      content: const Text('保存に成功しました'),
      backgroundColor: Colors.green, // スナックバーの背景色を緑に設定
      behavior: SnackBarBehavior.floating, // スナックバーを浮かせる
      margin: const EdgeInsets.only(bottom: 10.0), // 下からのマージンを10に設定
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // 角丸の半径を設定
      duration: const Duration(seconds: 2), // 表示時間を2秒に設定
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// 保存に失敗した場合にアラートを表示
  void _showAlertDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          titleValue: '保存に失敗しました',
          contentValue: 'ログの内容を確認してください',
          onOkPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
