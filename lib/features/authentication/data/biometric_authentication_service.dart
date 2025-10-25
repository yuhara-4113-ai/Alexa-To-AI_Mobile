import 'package:local_auth/local_auth.dart';

/// 生体認証をラップするサービス
class BiometricAuthenticationService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> auth() async {
    final canCheck = await _auth.canCheckBiometrics;
    if (!canCheck) return false;
    final didAuthenticate = await _auth.authenticate(
     localizedReason: 'Authenticate to access secure data',
      options: const AuthenticationOptions(biometricOnly: true),
    );
    return didAuthenticate;
  }
}
