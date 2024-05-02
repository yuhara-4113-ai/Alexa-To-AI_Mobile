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
  String aiTone = '';

  // 保存済みフラグ(保存したらtrueになる)
  @HiveField(1)
  bool isSaved = false;

  SettingScreenModel();

  // Equatableを使うことで、==演算子を使って比較できる
  @override
  List<Object> get props => [aiTone];

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
      // user_idはログイン機能が必要になって実装したら適宜変更する。とりあえず固定値
      'user_id': '1',
      'tone': aiTone,
    });
  }
}
