import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alexa_to_ai/features/settings/domain/models/setting_screen_model.dart';

final settingScreenModelState =
    StateProvider<SettingScreenModel>((ref) => SettingScreenModel());
