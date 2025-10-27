import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:alexa_to_ai/features/settings/domain/models/ai_model.dart';
import 'package:alexa_to_ai/features/settings/domain/models/setting_screen_model.dart';
import 'package:alexa_to_ai/features/settings/domain/models/available_models.dart';

/// ローカルデータベース
late Box<SettingScreenModel> settingModelBox;
const String settingModelBoxName = 'settingModelBox';
const String settingModelBoxKey = 'settingData';

late Box<AvailableModels> availableModelsBox;
const String availableModelsBoxName = 'availableModelsBox';
const String availableModelsBoxKey = 'availableModels';

/// 設定情報を管理する Hive ボックスの初期化
Future<void> initSettingsHiveBox() async {
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(SettingScreenModelAdapter());
  Hive.registerAdapter(AIModelAdapter());
  Hive.registerAdapter(AvailableModelsAdapter());
  // 初期化時に open して後続処理で自由に使えるようにする
  settingModelBox = await Hive.openBox<SettingScreenModel>(settingModelBoxName);
  // データがない場合は初期化して事実上 null が発生しない状態にする
  if (settingModelBox.get(settingModelBoxKey) == null) {
    settingModelBox.put(settingModelBoxKey, SettingScreenModel());
  }
  
  // Available models box initialization
  availableModelsBox = await Hive.openBox<AvailableModels>(availableModelsBoxName);
  if (availableModelsBox.get(availableModelsBoxKey) == null) {
    availableModelsBox.put(availableModelsBoxKey, AvailableModels());
  }
}
