import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// Layanan penyimpanan lokal untuk fitur "Ingat Saya" pada halaman login.
/// Menyimpan dan memuat status `rememberMe`, `email`, dan `password`.
class AuthStorageService {
  // Kunci penyimpanan di SharedPreferences (dibuat private agar konsisten)
  static const String _keyRememberMe = 'remember_me';
  static const String _keySavedEmail = 'saved_email';
  static const String _keySavedPassword = 'saved_password';

  /// Menyimpan kredensial jika `rememberMe` bernilai `true`, atau menghapusnya
  /// jika `rememberMe` bernilai `false`.
  Future<void> saveCredentials({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    // Mengambil instance penyimpanan lokal perangkat
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (rememberMe) {
      await prefs.setBool(_keyRememberMe, true);
      await prefs.setString(_keySavedEmail, email);
      await prefs.setString(_keySavedPassword, password);
    } else {
      await prefs.remove(_keyRememberMe);
      await prefs.remove(_keySavedEmail);
      await prefs.remove(_keySavedPassword);
    }
  }

  Future loadCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool rememberMe = prefs.getBool(_keyRememberMe) ?? false;

    if (rememberMe) {
      return <String, dynamic>{
        'rememberMe': true,
        'email': prefs.getString(_keySavedEmail) ?? '',
        'password': prefs.getString(_keySavedPassword) ?? '',
      };
    }

    return <String, dynamic>{
      'rememberMe': false,
      'email': '',
      'password': '',
    };
  }

  Future<void> clearCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRememberMe);
    await prefs.remove(_keySavedEmail);
    await prefs.remove(_keySavedPassword);
  }
}