import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/setting_screen_model.dart';

// 設定画面のmodelの状態管理
final settingScreenModelState =
    StateProvider<SettingScreenModel>((ref) => SettingScreenModel());
