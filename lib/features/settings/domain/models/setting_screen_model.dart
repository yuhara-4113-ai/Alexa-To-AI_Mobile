import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import 'package:alexa_to_ai/features/settings/data/local/settings_hive_box.dart';
import 'package:alexa_to_ai/features/settings/domain/models/ai_model.dart';

part 'setting_screen_model.g.dart';

final log = Logger();

/// 設定画面のモデル
/// build_runner で Adapter (Hive に保存するためのバイナリデータ) を生成
/// 保存対象の項目は @HiveField で指定し、変更時は build_runner を再実行する
@HiveType(typeId: 0)
class SettingScreenModel extends HiveObject {
  @HiveField(0)
  String aiTone = '';

  @HiveField(1)
  bool isSaved = false;

  @HiveField(2)
  String selectedType = AITypes.chatGPT.name;

  @HiveField(3)
  Map<String, AIModel> aiModelsPerType;

  @HiveField(4)
  String userId = '';

  SettingScreenModel() : aiModelsPerType = {} {
    aiModelsPerType = initAiModelsPerType();
  }

  Map<String, AIModel> initAiModelsPerType() {
    final Map<String, AIModel> initMap = {};
    for (final val in AITypes.values) {
      initMap[val.name] = AIModel(apiKey: '', model: val.models[0]);
    }
    return initMap;
  }

  void setAiModelsPerType(String type, AIModel aiModel) {
    final AIModel existing = aiModelsPerType[type]!;
    existing.apiKey = aiModel.apiKey;
    existing.model = aiModel.model;
  }

  AIModel getAIModel() {
    final AIModel? aiModel = aiModelsPerType[selectedType];
    if (aiModel == null) {
      return AIModel();
    }
    return aiModel;
  }

  Map<String, AIModel> copyAiModelsPerType() {
    return aiModelsPerType
        .map((key, value) => MapEntry(key, AIModel.from(value)));
  }

  bool compareWithLocalDB() {
    final settingModel = settingModelBox.get(settingModelBoxKey);
    final isCompareWithLocalDB = !settingScreenModelEquals(settingModel!);
    log.i('compareWithLocalDB_result: $isCompareWithLocalDB');

    return isCompareWithLocalDB;
  }

  bool settingScreenModelEquals(SettingScreenModel box) {
    return aiTone == box.aiTone &&
        selectedType == box.selectedType &&
        mapEquals(aiModelsPerType, box.aiModelsPerType);
  }

  bool mapEquals(
    Map<String, AIModel> current,
    Map<String, AIModel> boxMap,
  ) {
    if (current.length != boxMap.length) {
      return false;
    }
    for (final key in current.keys) {
      final AIModel model = current[key]!;
      final AIModel boxModel = boxMap[key]!;
      if (model.apiKey != boxModel.apiKey || model.model != boxModel.model) {
        return false;
      }
    }
    return true;
  }

  String convertJsonToCloudSave() {
    return jsonEncode({
      'user_id': userId,
      'tone': aiTone,
      'selected_ai': selectedType,
      'ai_info': getAIModel(),
    });
  }

  String toJson() {
    return jsonEncode({
      'aiTone': aiTone,
      'isSaved': isSaved,
      'selectedType': selectedType,
      'aiModelsPerType': aiModelsPerType,
    });
  }
}
