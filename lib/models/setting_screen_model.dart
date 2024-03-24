import 'package:hive/hive.dart';
part 'setting_screen_model.g.dart';

/// 設定画面のmodel
/// build_runnerでAdapter(Hiveに保存するためのバイナリデータ)を生成
@HiveType(typeId: 0)
class SettingScreenModel {
  // 名前
  @HiveField(0)
  String aiName = '';

  // 性格
  @HiveField(1)
  String aiPersonality = aiPersonalityList[0];
  // 性格のリスト
  static List<String> aiPersonalityList = [
    'A',
    'B',
    'C',
  ];

  // 口調
  @HiveField(2)
  String aiTone = aiToneList[0];
  // 性格のリスト
  static List<String> aiToneList = [
    'D',
    'E',
    'F',
  ];
}
