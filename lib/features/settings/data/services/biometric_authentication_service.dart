import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

final log = Logger();

class BiometricAuthenticationService {
  BiometricAuthenticationService._privateConstructor();
  static final BiometricAuthenticationService _instance =
      BiometricAuthenticationService._privateConstructor();
  factory BiometricAuthenticationService() => _instance;

  final LocalAuthentication localAuthentication = LocalAuthentication();

  Future<bool> auth() async {
    try {
      return await localAuthentication.authenticate(
        localizedReason: '生体認証でログインしてください',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      log.e(e.toString());
      return false;
    }
  }
}
