import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:alexa_to_ai/database/database.dart';
import 'package:alexa_to_ai/models/setting_screen_model.dart';
import 'package:alexa_to_ai/providers/setting_screen_model_provider.dart';
import 'package:alexa_to_ai/services/cloud_storage_service.dart';
import 'package:alexa_to_ai/widgets/alert_dialog.dart';
import 'package:alexa_to_ai/widgets/elevated_button.dart';
import 'package:alexa_to_ai/widgets/labeled_dropdown_field.dart';
import 'package:alexa_to_ai/widgets/labeled_input_field.dart';
import 'package:alexa_to_ai/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

    // AIのモデル(GPT3.5Turbo、GPT4Turboなど)
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
    ValueNotifier<bool> isApiKeyVisible = useState<bool>(true);

    // Scaffoldを使用して基本的なレイアウトを作成
    return Scaffold(
      appBar: AppBar(
        title: Text(name), // アプリバーのタイトル
      ),
      // SingleChildScrollViewでラップして、画面が小さくなったときにスクロールできるようにする
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'AIのレスポンス'),
              const SizedBox(height: 8.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 口調/キャラクター名の入力フォーム
                      // TODO TextFieldの入力中に画面描画が行われると、フォーカスが失われるため、キーボードの予測変換が閉じてしまう
                      LabeledInputField(
                        label: '口調/キャラクター名',
                        controller: aiToneController,
                        placeholder: 'ツンデレ、スポンジボブなど',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const SectionTitle(title: '使用するAI'),
              const SizedBox(height: 8.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // AIの種類(ChatGPT、Geminiなど)の選択
                      LabeledDropdownField(
                        label: 'AIの種類',
                        selected: selectedType.value,
                        options: aiType.values.toList(),
                        onChanged: (String? newValue) {
                          selectedType.value = newValue!;
                        },
                      ),
                      // 選択されたAIのAPIキーの入力フォーム
                      const SizedBox(height: 16.0),
                      LabeledInputField(
                        label: 'APIキー',
                        placeholder: 'モデルのAPIキーを入力してください',
                        controller: apiKeyController,
                        obscureText: isApiKeyVisible.value,
                        // APIキーの入力内容は表示/非表示を切り替え可能
                        suffixIcon: IconButton(
                          icon: Icon(
                            // _obscureTextの値に応じてアイコンを切り替える
                            isApiKeyVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            // _obscureTextの値を反転
                            isApiKeyVisible.value = !isApiKeyVisible.value;
                          },
                        ),
                      ),
                      // 選択されたAIのモデル(GPT3.5Turbo、GPT4Turboなど)の選択
                      const SizedBox(height: 16.0),
                      LabeledDropdownField(
                        label: 'モデル',
                        selected: selectedModel.value,
                        options: modelConfig[settingScreenModelProvider
                                .getKeyFromSelectedType()]!
                            .toList(),
                        onChanged: (String? newValue) {
                          selectedModel.value = newValue!;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // 保存ボタン
              const SizedBox(height: 16.0),
              SizedBox(
                // ボタンを親ウィジェットの横幅と合わせる
                width: double.infinity,
                child: CustomElevatedButton(
                  text: isCompareWithLocalDB.value ? '変更内容を保存' : '設定に変更はありません',
                  // 保存ボタンが押されたときに実行される関数
                  // 保存内容に差分がない場合は非活性
                  onPressedFunction: isCompareWithLocalDB.value
                      ? () {
                          _saveSettings(settingScreenModelProvider,
                              isCompareWithLocalDB, context);
                        }
                      : null,
                ),
              ),
            ],
          ),
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
      ..aiModelsPerType = model.copyAiModelsPerType();

    // ローカルDBに保存
    await settingModelBox.put(settingModelBoxKey, saveData);

    debugPrint('_saveSettings box: ${saveData.toJson()}');

    // boxとの差分状態を更新
    isCompareWithLocalDB.value = model.compareWithLocalDB();

    // 設定内容をクラウド上に保存する関数を実行
    // 結果を画面に表示
    cloudStorageService.saveAISettingData(model).then((success) {
      if (success) {
        // _showSnackBar(context);
      } else {
        _showAlertDialog(context);
      }
    }).catchError((error) {
      debugPrint(error.toString());
      debugPrint(error.stackTrace.toString());
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
        settingModel.copyAiModelsPerType();
  }

  // NOTE: 実際に使った結果、スナックバーの表示は不要(失敗の時に通知できれば十分)だったのでコメントアウト(将来使う時に備えて残しておく)
  /// 保存に成功した場合にスナックバーを表示
  // void _showSnackBar(context) {
  //   // 共通のスナックバーを生成
  //   SnackBar snackBar = InfoSnackBar(contentText: '保存に成功しました', context: context)
  //       .buildSnackBar();
  //   // スナックバーを表示
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

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
