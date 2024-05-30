import 'package:alexa_to_ai/models/setting_screen_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 設定画面のmodelの状態管理
final settingScreenModelState =
    StateProvider<SettingScreenModel>((ref) => SettingScreenModel());
