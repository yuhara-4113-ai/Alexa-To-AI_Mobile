import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:alexa_to_ai/features/authentication/data/services/login_authentication_service.dart';
import 'package:alexa_to_ai/features/settings/data/local/settings_hive_box.dart';
import 'package:alexa_to_ai/features/settings/data/remote/cloud_storage_service.dart';
import 'package:alexa_to_ai/features/settings/data/services/biometric_authentication_service.dart';
import 'package:alexa_to_ai/features/settings/domain/models/ai_model.dart';
import 'package:alexa_to_ai/features/settings/domain/models/setting_screen_model.dart';
import 'package:alexa_to_ai/features/settings/presentation/providers/biometric_authentication_service_provider.dart';
import 'package:alexa_to_ai/features/settings/presentation/providers/setting_screen_model_provider.dart';
import 'package:alexa_to_ai/shared/widgets/button/custom_elevated_button.dart';
import 'package:alexa_to_ai/shared/widgets/common/custom_card.dart';
import 'package:alexa_to_ai/shared/widgets/common/section_title.dart';
import 'package:alexa_to_ai/shared/widgets/input/labeled_dropdown_field.dart';
import 'package:alexa_to_ai/shared/widgets/input/labeled_input_field.dart';
import 'package:alexa_to_ai/shared/widgets/notification/custom_alert_dialog.dart';

final CloudStorageService cloudStorageService = CloudStorageService();
final Logger log = Logger();

class SettingScreen extends HookConsumerWidget {
  static String name = '設定画面';
  final SettingScreenModel settingScreenModel;

  const SettingScreen({super.key, required this.settingScreenModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingScreenModel settingScreenModelProvider =
        ref.watch(settingScreenModelState);

    useEffect(() {
      _setViewModel(settingScreenModelProvider);
      return null;
    }, const []);

    final ValueNotifier<bool> isCompareWithLocalDB =
        useState(settingScreenModelProvider.compareWithLocalDB());

    final TextEditingController aiToneController = createAiToneController(
      settingScreenModelProvider,
      isCompareWithLocalDB,
    );

    final TextEditingController apiKeyController = createApiKeyController(
      settingScreenModelProvider,
      isCompareWithLocalDB,
    );

    final ValueNotifier<String> selectedModel =
        useState<String>(settingScreenModelProvider.getAIModel().model);
    useEffect(() {
      void listener() {
        settingScreenModelProvider.getAIModel().model = selectedModel.value;
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      }

      selectedModel.addListener(listener);
      return () => selectedModel.removeListener(listener);
    }, const []);

    final ValueNotifier<String> selectedType =
        useState<String>(settingScreenModelProvider.selectedType);
    useEffect(() {
      void listener() {
        settingScreenModelProvider.selectedType = selectedType.value;
        selectedModel.value = settingScreenModelProvider.getAIModel().model;
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      }

      selectedType.addListener(listener);
      return () => selectedType.removeListener(listener);
    }, const []);

    final ValueNotifier<bool> isApiKeyVisible = useState<bool>(true);
    final ValueNotifier<bool> isAuthenticating = useState(false);
    final BiometricAuthenticationService biometricAuthenticationService =
        ref.watch(biometricAuthProvider);

    Future<void> authenticate() async {
      try {
        final bool authResult = await biometricAuthenticationService.auth();
        if (authResult) {
          isAuthenticating.value = true;
          isApiKeyVisible.value = false;
        }
      } catch (e) {
        isAuthenticating.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'AIのレスポンス'),
              const SizedBox(height: 8.0),
              CustomCard(
                content: Column(
                  children: [
                    LabeledInputField(
                      label: '口調/キャラクター名',
                      controller: aiToneController,
                      placeholder: 'ツンデレ、スポンジボブなど',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const SectionTitle(title: '使用するAI'),
              const SizedBox(height: 8.0),
              CustomCard(
                content: Column(
                  children: [
                    LabeledDropdownField(
                      label: 'AIの種類',
                      selected: selectedType.value,
                      options: AITypes.values.map((e) => e.name).toList(),
                      onChanged: (String? newValue) {
                        selectedType.value = newValue!;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    LabeledDropdownField(
                      label: 'モデル',
                      selected: selectedModel.value,
                      options: AITypes.getAITypeByName(
                        settingScreenModelProvider.selectedType,
                      ).models.toList(),
                      onChanged: (String? newValue) {
                        selectedModel.value = newValue!;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    LabeledInputField(
                      label: 'APIキー',
                      placeholder: 'モデルのAPIキーを入力してください',
                      controller: apiKeyController,
                      obscureText: isApiKeyVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isApiKeyVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          if (isAuthenticating.value) {
                            isApiKeyVisible.value = !isApiKeyVisible.value;
                          } else {
                            authenticate();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  text: isCompareWithLocalDB.value ? '変更内容を保存' : '設定に変更はありません',
                  onPressed: isCompareWithLocalDB.value
                      ? () {
                          _saveSettings(
                            settingScreenModelProvider,
                            isCompareWithLocalDB,
                            context,
                          );
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
    ValueNotifier<bool> isCompareWithLocalDB,
  ) {
    final TextEditingController aiToneController = useTextEditingController();
    aiToneController.text = settingScreenModelProvider.aiTone;

    useEffect(() {
      void listener() {
        settingScreenModelProvider.aiTone = aiToneController.text;
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      }

      aiToneController.addListener(listener);
      return () => aiToneController.removeListener(listener);
    }, const []);
    return aiToneController;
  }

  TextEditingController createApiKeyController(
    SettingScreenModel settingScreenModelProvider,
    ValueNotifier<bool> isCompareWithLocalDB,
  ) {
    final TextEditingController apiKeyController = useTextEditingController();

    final AIModel aiModel = settingScreenModelProvider.getAIModel();
    apiKeyController.text = aiModel.apiKey;

    useEffect(() {
      void listener() {
        final AIModel aiModel = settingScreenModelProvider.getAIModel();
        aiModel.apiKey = apiKeyController.text;
        isCompareWithLocalDB.value =
            settingScreenModelProvider.compareWithLocalDB();
      }

      apiKeyController.addListener(listener);
      return () => apiKeyController.removeListener(listener);
    }, const []);
    return apiKeyController;
  }

  Future<void> _saveSettings(
    SettingScreenModel model,
    ValueNotifier<bool> isCompareWithLocalDB,
    BuildContext context,
  ) async {
    final SettingScreenModel saveData = SettingScreenModel()
      ..aiTone = model.aiTone
      ..isSaved = true
      ..selectedType = model.selectedType
      ..aiModelsPerType = model.copyAiModelsPerType();

    await settingModelBox.put(settingModelBoxKey, saveData);

    log.i('_saveSettings box: ${saveData.toJson()}');

    isCompareWithLocalDB.value = model.compareWithLocalDB();

    final LoginAuthenticationService loginAuthenticationService =
        LoginAuthenticationService();
    late CognitoAuthSession session;
    try {
      session = await loginAuthenticationService.getAuthSession();
    } catch (e) {
      await Amplify.Auth.signOut();
    }
    final String userId = loginAuthenticationService.getUserId(session);
    model.userId = userId;
    final String idToken = loginAuthenticationService.getIdToken(session);

    if (!context.mounted) {
      return;
    }

    cloudStorageService.saveAISettingData(model, idToken).then((bool success) {
      if (!context.mounted) {
        return;
      }
      if (!success) {
        _showAlertDialog(context);
      }
    }).catchError((Object error) {
      log.e(error.toString());
      log.e(error is Error ? error.stackTrace.toString() : '');
    });
  }

  Future<void> _setViewModel(SettingScreenModel viewModel) async {
    final SettingScreenModel? settingModel =
        settingModelBox.get(settingModelBoxKey);
    log.e('ローカルDBの設定を状態保持中のmodelに反映');
    log.i('_setViewnModel box: ${settingModel?.toJson()}');
    log.i('_setViewnModel this: ${viewModel.toJson()}');

    viewModel.aiTone = settingModel!.aiTone;
    viewModel.selectedType = settingModel.selectedType;
    viewModel.aiModelsPerType = settingModel.copyAiModelsPerType();
  }

  void _showAlertDialog(BuildContext context) {
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
