import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

final log = Logger();

class BiometricAuthenticationService {
  // インスタンスをシングルトンにする
  BiometricAuthenticationService._privateConstructor();
  static final _instance = BiometricAuthenticationService._privateConstructor();
  factory BiometricAuthenticationService() {
    return _instance;
  }

  // 端末の生体認証を使えるようにするパッケージのインスタンス
  export 'package:alexa_to_ai/features/authentication/data/biometric_authentication_service.dart';
