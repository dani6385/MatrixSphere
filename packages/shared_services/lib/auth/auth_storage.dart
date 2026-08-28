import 'package:shared_core/shared_core.dart';

class AuthStorage {
  static const String prefRememberMeKey = 'auth_remember_me';
  static const String prefSavedEmailKey = 'auth_saved_email';
  static const String prefSavedPasswordKey = 'auth_saved_password';
  static const String prefTokenKey = 'user_token';

  // Menyimpan Token Pengguna
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefTokenKey, token);
  }

  // Menghapus Token (saat Logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefTokenKey);
  }

  // Memuat Kredensial Tersimpan
  Future<Map<String, dynamic>> loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isRemembered = prefs.getBool(prefRememberMeKey) ?? false;

      if (isRemembered) {
        return {
          'rememberMe': true,
          'email': prefs.getString(prefSavedEmailKey) ?? '',
          'password': prefs.getString(prefSavedPasswordKey) ?? '',
        };
      }
    } catch (_) {}
    return {'rememberMe': false, 'email': '', 'password': ''};
  }

  // Menyimpan atau Menghapus Kredensial (Remember Me)
  Future<void> saveOrClearCredentials(
      bool rememberMe, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setBool(prefRememberMeKey, true);
        await prefs.setString(prefSavedEmailKey, email.trim());
        await prefs.setString(prefSavedPasswordKey, password);
      } else {
        await prefs.setBool(prefRememberMeKey, false);
        await prefs.remove(prefSavedEmailKey);
        await prefs.remove(prefSavedPasswordKey);
      }
    } catch (_) {}
  }
}