import 'package:alexa_to_ai/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// シングルトンインスタンスを提供するProvider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
