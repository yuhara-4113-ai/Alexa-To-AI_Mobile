import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alexa_to_ai/features/settings/data/services/biometric_authentication_service.dart';

final biometricAuthProvider = Provider<BiometricAuthenticationService>((ref) {
  return BiometricAuthenticationService();
});
