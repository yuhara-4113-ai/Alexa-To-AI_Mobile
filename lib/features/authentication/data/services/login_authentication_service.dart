import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:logger/logger.dart';

import 'package:alexa_to_ai/features/authentication/config/amplifyconfiguration.dart';

final log = Logger();

class LoginAuthenticationService {
  LoginAuthenticationService._privateConstructor();
  static final LoginAuthenticationService _instance =
      LoginAuthenticationService._privateConstructor();
  factory LoginAuthenticationService() => _instance;

  Future<void> configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      log.i('Amplify configured successfully');
    } catch (e) {
      log.e('Failed to configure Amplify: $e');
    }
  }

  Future<CognitoAuthSession> getAuthSession() async {
    try {
      final AuthSession response = await Amplify.Auth.fetchAuthSession();
      if (!response.isSignedIn) {
        throw Exception('Not signed in');
      }
      return response as CognitoAuthSession;
    } catch (e) {
      log.e('Get ID token failed: $e');
      throw Exception('Not signed in');
    }
  }

  String getUserId(CognitoAuthSession session) {
    final List<dynamic> identities = session.userPoolTokensResult.value.idToken
        .claims.customClaims['identities'] as List<dynamic>;
    final List<Map<String, dynamic>> identitiesList =
        identities.cast<Map<String, dynamic>>();
    final String userId = identitiesList[0]['userId'];
    return userId;
  }

  String getIdToken(CognitoAuthSession session) {
    final idToken = session.userPoolTokensResult.value.idToken;
    return idToken.raw;
  }
}
