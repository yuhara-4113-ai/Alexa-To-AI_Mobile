import 'package:alexa_to_ai/auth/amplifyconfiguration.dart';
import 'package:flutter/foundation.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class LoginAuthenticationService {
  // インスタンスをシングルトンにする
  LoginAuthenticationService._privateConstructor();
  static final _instance = LoginAuthenticationService._privateConstructor();
  factory LoginAuthenticationService() {
    return _instance;
  }

  Future<void> configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      // Amplifyの設定をロード
      await Amplify.configure(amplifyconfig);
      debugPrint('Amplify configured successfully');
    } catch (e) {
      debugPrint('Failed to configure Amplify: $e');
    }
  }

  Future<String> getUserId() async {
    try {
      AuthUser user = await Amplify.Auth.getCurrentUser();
      debugPrint('User: ${user.toJson()}');
      // userIdだとCognitoのユーザーIDになってしまう。ユニークだが、ユーザープールが変わるとIDが変わってしまうため、より不変性が強いAmazonアカウントID(username)を返す
      return user.username;
    } catch (e) {
      debugPrint('Get user ID failed: $e');
      // エラーを再スロー
      rethrow;
    }
  }
}
