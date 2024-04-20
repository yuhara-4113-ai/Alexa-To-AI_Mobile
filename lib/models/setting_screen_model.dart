import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../database/database.dart';
part 'setting_screen_model.g.dart';

/// 設定画面のmodel
/// build_runnerでAdapter(Hiveに保存するためのバイナリデータ)を生成
/// 保存対象の項目は@HiveFieldで指定
/// 保存する項目を変更した場合は「flutter packages pub run build_runner build」を実行して保存する実体のファイルを更新する
@HiveType(typeId: 0)
class SettingScreenModel extends HiveObject with EquatableMixin {
  // キャラクター名(口調)
  @HiveField(0)
  String aiName = '';

  // 性格
  @HiveField(1)
  String aiPersonality = aiPersonalityList[0];
  // 性格のリスト
  static List<String> aiPersonalityList = [
    '',
    '優しい',
    '厳しい',
    'ツンデレ',
    'クール',
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

  // 保存済みフラグ(保存したらtrueになる)
  @HiveField(3)
  bool isSaved = false;

  SettingScreenModel();

  // Equatableを使うことで、==演算子を使って比較できる
  @override
  List<Object> get props => [aiName, aiPersonality, aiTone];

  /// 「ローカルDB」と中身を比較
  bool compareWithLocalDB() {
    final settingModel = settingModelBox.get(settingModelBoxKey);
    final isCompareWithLocalDB = !(this == settingModel);

    debugPrint('box: ${settingModel.toString()}');
    debugPrint('this: ${toString()}');

    debugPrint('isCompareWithLocalDB: $isCompareWithLocalDB');

    return !(this == settingModel);
  }

  String toJson() {
    return jsonEncode({
      // TODO user_idはログイン機能を実装したら変更する
      'user_id': '1',
      // TODO クラウド側とIFがあってないので調整。
      'tone': aiName,
      'personality': aiPersonality,
      // TODO クラウド側とIFがあってないので調整。typeは使用するAIの種類(ChatGPTなど)。
      'type': aiTone,
    });
  }
}
