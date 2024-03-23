/// 設定画面のmodel
class SettingScreenModel {
  // 名前
  String aiName = '';

  // 性格
  String aiPersonality = aiPersonalityList[0];
  // 性格のリスト
  static List<String> aiPersonalityList = [
    'A',
    'B',
    'C',
  ];

  // 口調
  String aiTone = aiToneList[0];
  // 性格のリスト
  static List<String> aiToneList = [
    'D',
    'E',
    'F',
  ];
}
