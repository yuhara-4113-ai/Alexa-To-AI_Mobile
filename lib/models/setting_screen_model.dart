import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../database/database.dart';
part 'setting_screen_model.g.dart';

/// 設定画面のmodel
/// build_runnerでAdapter(Hiveに保存するためのバイナリデータ)を生成
@HiveType(typeId: 0)
class SettingScreenModel extends HiveObject with EquatableMixin {
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

  // Equatableを使うことで、==演算子を使って比較できる
  @override
  List<Object> get props => [aiName, aiPersonality, aiTone];

  /// 設定の保存が必要かどうかを判定
  /// 「状態保持中のmodel」と「ローカルDB」を比較し、差分がある場合は保存が必要
  bool isSaveNeededForSettings(SettingScreenModel settingScreenModelProvider) {
    final settingModel = settingModelBox.get(settingModelBoxKey);
    return settingModel == settingScreenModelProvider;
  }
}
