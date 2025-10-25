import 'package:alexa_to_ai/features/authentication/data/biometric_authentication_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// シングルトンインスタンスを提供するProvider
final biometricAuthProvider = Provider<BiometricAuthenticationService>((ref) {
  return BiometricAuthenticationService();
});
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alexa_to_ai/features/authentication/data/biometric_authentication_service.dart';

// シングルトンインスタンスを提供するProvider
final biometricAuthProvider = Provider<BiometricAuthenticationService>((ref) {
  return BiometricAuthenticationService();
});
