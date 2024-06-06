import 'package:alexa_to_ai/auth/amplifyconfiguration.dart';
import 'package:alexa_to_ai/database/database.dart';
import 'package:alexa_to_ai/widgets/navigation/footer.dart';
import 'package:alexa_to_ai/widgets/theme/dark_theme_data.dart';
import 'package:alexa_to_ai/widgets/theme/light_theme_data.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// アプリケーションのエントリーポイント
void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // アプリケーション起動時の処理
  @override
  void initState() {
    super.initState();
    // initState内で非同期処理を行う場合はaddPostFrameCallbackを使用する
    someAsyncFunction();
  }

  Future<void> someAsyncFunction() async {
    // .envファイルの読み込み
    await dotenv.load();
    // ローカルデータベースを初期化
    WidgetsFlutterBinding.ensureInitialized();
    await initHive();
    // Cognitoで認証を行うための事前処理
    await _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      // Amplifyの設定をロード
      await Amplify.configure(amplifyconfig);
      debugPrint('Amplify configured successfully');
    } catch (e) {
      debugPrint('Failed to configure Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        // 認証画面を表示
        builder: Authenticator.builder(),
        // 各画面の入力状態の保持に使用するProviderScope
        home: ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.system,
            darkTheme: const DarkThemeData().build(),
            theme: const LightThemeData().build(),
            home: const Footer(),
          ),
        ),
      ),
    );
  }
}
