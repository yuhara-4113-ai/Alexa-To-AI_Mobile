import 'dart:developer';

import 'package:alexa_to_ai/auth/amplifyconfiguration.dart';
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
      log('Amplify configured successfully');
    } catch (e) {
      log('Failed to configure Amplify: $e');
    }
  }

  /// 認証情報(ユーザーID、IDトークンなど)のセッションを取得
  Future<CognitoAuthSession> getAuthSession() async {
    try {
      final response = await Amplify.Auth.fetchAuthSession();
      // 未ログイン、セッション切れの場合は例外をスロー(呼び出し元でログイン画面に遷移させる)
      if (!response.isSignedIn) {
        throw Exception('Not signed in');
      }
      final session = response as CognitoAuthSession;
      return session;
    } catch (e) {
      log('Get ID token failed: $e');
      throw Exception('Not signed in');
    }
  }

  String getUserId(CognitoAuthSession session) {
    // userIdはカスタム項目(customClaims(dynamic型))に設定されているため、決め打ちで取得する
    final identities = session.userPoolTokensResult.value.idToken.claims
        .customClaims['identities'] as List<dynamic>;
    // List<dynamic> を List<Map<String, dynamic>> にキャストする
    final identitiesList = identities.cast<Map<String, dynamic>>();
    // 最初の identity から userId を取得
    final userId = identitiesList[0]['userId'];
    return userId;
  }

  /// IDトークン(base64でencodしたJWTのstring)を取得
  String getIdToken(CognitoAuthSession session) {
    final idToken = session.userPoolTokensResult.value.idToken;
    return idToken.raw;
  }
}
