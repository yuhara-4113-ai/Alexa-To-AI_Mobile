import 'dart:convert';

import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:alexa_to_ai/database/database.dart';
part 'setting_screen_model.g.dart';

/// 設定画面のmodel
/// build_runnerでAdapter(Hiveに保存するためのバイナリデータ)を生成
/// 保存対象の項目は@HiveFieldで指定
/// 保存する項目を変更した場合は「flutter packages pub run build_runner build」を実行して保存する実体のファイルを更新する
@HiveType(typeId: 0)
class SettingScreenModel extends HiveObject {
  // キャラクター名(口調)
  @HiveField(0)
  String aiTone = '';

  // 保存済みフラグ(保存したらtrueになる)
  @HiveField(1)
  bool isSaved = false;

  // 選択した種別(ChatGPT、Geminiなど)
  @HiveField(2)
  String selectedType = aiType[AITypes.chatGPT]!;

  // 種別ごとのAIModel
  @HiveField(3)
  Map<String, AIModel> aiModelsPerType;

  // コンストラクタ
  SettingScreenModel() : aiModelsPerType = {} {
    aiModelsPerType = initApiKeyForType();
  }

  Map<String, AIModel> initApiKeyForType() {
    Map<String, AIModel> initMap = {};
    for (var key in aiType.keys) {
      initMap[aiType[key]!] = AIModel();
    }
    return initMap;
  }

  void setApiKeyForType(String type, AIModel aiModel) {
    // インスタンスが共有されるため、そのまま代入ではなく個別に代入する
    AIModel a = aiModelsPerType[type]!;
    a.apiKey = aiModel.apiKey;
    a.model = aiModel.model;
  }

  AIModel getApiKeyForType() {
    AIModel? aiModel = aiModelsPerType[selectedType];
    // 未設定の場合は空のAIModelを返す
    if (aiModel == null) {
      return AIModel();
    }
    return aiModel;
  }

  /// AIModelのコピーを返す(Mapの値が独自classのため、ディープコピーする必要がある)
  Map<String, AIModel> copyApiKeyForType() {
    return aiModelsPerType
        .map((key, value) => MapEntry(key, AIModel.from(value)));
  }

  /// 「ローカルDB」と中身を比較
  bool compareWithLocalDB() {
    final settingModel = settingModelBox.get(settingModelBoxKey);
    final isCompareWithLocalDB = !settingScreenModelEquals(settingModel!);

    debugPrint('compareWithLocalDB_box: ${settingModel.toJson2()}');
    debugPrint('compareWithLocalDB_this: ${toJson2()}');

    debugPrint('compareWithLocalDB_result: $isCompareWithLocalDB');

    return isCompareWithLocalDB;
  }

  /// NOTE: EquatableMixinを使用していたが、廃止して自力で比較
  /// Mapは値が同じでもインスタンスが異なれば不一致判定されてしまい、ローカルDBとの比較に使用できなくなってしまった
  bool settingScreenModelEquals(SettingScreenModel box) {
    return aiTone == box.aiTone &&
        selectedType == box.selectedType &&
        mapEquals(aiModelsPerType, box.aiModelsPerType);
  }

  bool mapEquals(
      Map<String, AIModel> aiModelsPerType, Map<String, AIModel> boxMap) {
    // 第一チェック(設定が異なれば大体ここで弾ける)
    if (aiModelsPerType.length != boxMap.length) {
      return false;
    }
    // 第二チェック(Mapの中身を比較)
    for (var key in aiModelsPerType.keys) {
      AIModel model = aiModelsPerType[key]!;
      AIModel boxModel = boxMap[key]!;
      // 各項目で異なる物が1つでもあれば不一致とする
      if (model.apiKey != boxModel.apiKey || model.model != boxModel.model) {
        return false;
      }
    }
    return true;
  }

  // TODO クラウド保存用のJSONを返しているため、名前を適切に変更する
  String toJson() {
    return jsonEncode({
      // user_idはログイン機能が必要になって実装したら適宜変更する。とりあえず固定値
      'user_id': '1',
      'tone': aiTone,
      'selectedType': selectedType,
    });
  }

  String toJson2() {
    return jsonEncode({
      'aiTone': aiTone,
      'isSaved': isSaved,
      'selectedType': selectedType,
      'aiModelsPerType': aiModelsPerType,
    });
  }
}

enum AITypes {
  chatGPT,
  gemini,
  claude,
}

// AITypeをベタ書きするのはここだけ
final Map<AITypes, String> aiType = {
  AITypes.chatGPT: 'ChatGPT',
  AITypes.gemini: 'Gemini',
  AITypes.claude: 'Claude',
};
