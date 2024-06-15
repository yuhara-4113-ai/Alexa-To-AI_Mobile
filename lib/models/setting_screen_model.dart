import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:alexa_to_ai/database/database.dart';
import 'package:alexa_to_ai/models/ai_model.dart';
import 'package:hive/hive.dart';

part 'setting_screen_model.g.dart';

final log = Logger();

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
  String selectedType = AITypes.chatGPT.name;

  // 種別ごとのAIModel
  @HiveField(3)
  Map<String, AIModel> aiModelsPerType;

  // ユーザーID
  @HiveField(4)
  String userId = '';

  // コンストラクタ
  SettingScreenModel() : aiModelsPerType = {} {
    aiModelsPerType = initAiModelsPerType();
  }

  // enumからデフォルト値のMapを作成
  Map<String, AIModel> initAiModelsPerType() {
    Map<String, AIModel> initMap = {};
    for (var val in AITypes.values) {
      initMap[val.name] = AIModel(apiKey: '', model: val.models[0]);
    }
    return initMap;
  }

  void setAiModelsPerType(String type, AIModel aiModel) {
    // インスタンスが共有されるため、そのまま代入ではなく個別に代入する
    AIModel a = aiModelsPerType[type]!;
    a.apiKey = aiModel.apiKey;
    a.model = aiModel.model;
  }

  AIModel getAIModel() {
    AIModel? aiModel = aiModelsPerType[selectedType];
    // 未設定の場合はChatGPTを設定したAIModelを返す
    if (aiModel == null) {
      return AIModel();
    }
    return aiModel;
  }

  /// AIModelのコピーを返す(Mapの値が独自classのため、ディープコピーする必要がある)
  Map<String, AIModel> copyAiModelsPerType() {
    return aiModelsPerType
        .map((key, value) => MapEntry(key, AIModel.from(value)));
  }

  /// 「ローカルDB」と中身を比較
  bool compareWithLocalDB() {
    final settingModel = settingModelBox.get(settingModelBoxKey);
    final isCompareWithLocalDB = !settingScreenModelEquals(settingModel!);
    log.i('compareWithLocalDB_result: $isCompareWithLocalDB');

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

  // クラウド保存用のJSONを返す
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
