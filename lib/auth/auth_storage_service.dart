import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const String _keyRememberMe = 'remember_me';
  static const String _keySavedEmail = 'saved_email';
  static const String _keySavedPassword = 'saved_password';

  Future<void> saveCredentials({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setBool(_keyRememberMe, true);
      await prefs.setString(_keySavedEmail, email);
      await prefs.setString(_keySavedPassword, password);
    } else {
      // Hanya menghapus kunci spesifik login, BUKAN prefs.clear()
      await prefs.remove(_keyRememberMe);
      await prefs.remove(_keySavedEmail);
      await prefs.remove(_keySavedPassword);
    }
  }

  /// Membaca data yang tersimpan saat aplikasi pertama kali dibuka
  Future<Map<String, dynamic>> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final bool rememberMe = prefs.getBool(_keyRememberMe) ?? false;

    if (rememberMe) {
      return {
        'rememberMe': true,
        'email': prefs.getString(_keySavedEmail) ?? '',
        'password': prefs.getString(_keySavedPassword) ?? '',
      };
    }

    return {
      'rememberMe': false,
      'email': '',
      'password': '',
    };
  }
}