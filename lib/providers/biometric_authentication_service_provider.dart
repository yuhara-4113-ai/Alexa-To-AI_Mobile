import 'package:alexa_to_ai/services/biometric_authentication_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// シングルトンインスタンスを提供するProvider
final biometricAuthProvider = Provider<BiometricAuthenticationService>((ref) {
  return BiometricAuthenticationService();
});
