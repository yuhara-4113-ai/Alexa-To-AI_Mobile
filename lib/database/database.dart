import 'package:flutter_test1/models/setting_screen_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

/// ローカルデータベース
late Box<SettingScreenModel> settingModelBox;
const String settingModelBoxName = 'settingModelBox';
const String settingModelBoxKey = 'settingData';

/// ローカルデータベースの初期化
Future<void> initHive() async {
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(SettingScreenModelAdapter());
  // 初期化時にopenして後続処理で自由に使えるようにする
  settingModelBox = await Hive.openBox<SettingScreenModel>(settingModelBoxName);
  // データがない場合は初期化して事実上nullが発生しない状態にする
  if (settingModelBox.get(settingModelBoxKey) == null) {
    settingModelBox.put(settingModelBoxKey, SettingScreenModel());
  }
}
