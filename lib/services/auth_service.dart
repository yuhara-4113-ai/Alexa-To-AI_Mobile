import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: '生体認証でログインしてください',
        options: const AuthenticationOptions(
          // 生体認証以外のローカル認証はしない
          useErrorDialogs: true,
          // システムによってアプリがバックグラウンドになってもプラグイン側が認証失敗を返さないようにする
          // 認証時に電話や他のアプリを開いた状態から、再度認証画面に戻ってきた際に認証を再試行する
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
