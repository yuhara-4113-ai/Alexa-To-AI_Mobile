import 'package:alexa_to_ai/app/navigation/footer.dart';
import 'package:alexa_to_ai/app/theme/dark_theme_data.dart';
import 'package:alexa_to_ai/app/theme/light_theme_data.dart';
import 'package:alexa_to_ai/features/authentication/data/services/login_authentication_service.dart';
import 'package:alexa_to_ai/features/settings/data/local/settings_hive_box.dart';
import 'package:alexa_to_ai/features/settings/data/services/model_initialization_service.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Global key for showing snackbar from anywhere
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

// アプリケーションのエントリーポイント
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // アプリ起動時の非同期処理を実行
  await someAsyncFunction();
  runApp(const App());
}

Future<void> someAsyncFunction() async {
  await dotenv.load();
  await initSettingsHiveBox();
  final loginAuthenticationService = LoginAuthenticationService();
  await loginAuthenticationService.configureAmplify();
  
  // Initialize and fetch AI models at startup
  final modelInitService = ModelInitializationService();
  final bool modelWasReset = await modelInitService.initializeModels();
  
  // Show warning if model was reset
  if (modelWasReset) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text(
            '保存されたモデルが利用できないため、デフォルトのモデルに変更されました',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 5),
        ),
      );
    });
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      // サインイン画面(ソーシャルログインのボタンのみ)だけを表示したいが、独自で画面を用意する必要がある(めんどくさいので標準のUIを使用)
      // せめてユーザーIDなどを非表示(fieldsを空定義)にしてソーシャルログインが目立つようにしている
      signInForm: const SignInForm.custom(fields: []),
      signUpForm: const SignUpForm.custom(fields: []),
      // 各画面の入力状態の保持に使用するProviderScope
      child: ProviderScope(
        child: MaterialApp(
          // 未認証であれば認証画面を表示
          builder: Authenticator.builder(),
          scaffoldMessengerKey: scaffoldMessengerKey,
          themeMode: ThemeMode.system,
          darkTheme: const DarkThemeData().build(),
          theme: const LightThemeData().build(),
          home: const Footer(),
        ),
      ),
    );
  }
}
