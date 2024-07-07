import 'package:alexa_to_ai/database/database.dart';
import 'package:alexa_to_ai/services/login_authentication_service.dart';
import 'package:alexa_to_ai/widgets/navigation/footer.dart';
import 'package:alexa_to_ai/widgets/theme/dark_theme_data.dart';
import 'package:alexa_to_ai/widgets/theme/light_theme_data.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// アプリケーションのエントリーポイント
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // アプリ起動時の非同期処理を実行
  await someAsyncFunction();
  runApp(const App());
}

Future<void> someAsyncFunction() async {
  // .envファイルの読み込み
  await dotenv.load();
  // ローカルデータベースを初期化
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  // Cognitoで認証を行うための事前処理
  final loginAuthenticationService = LoginAuthenticationService();
  await loginAuthenticationService.configureAmplify();
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
          themeMode: ThemeMode.system,
          darkTheme: const DarkThemeData().build(),
          theme: const LightThemeData().build(),
          home: const Footer(),
        ),
      ),
    );
  }
}
