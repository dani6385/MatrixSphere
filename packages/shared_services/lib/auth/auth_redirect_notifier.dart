// d:\matrixsphere\apps\seller_sphere\lib\navigations\auth_redirect_notifier.dart
import 'dart:async';

import 'package:flutter/material.dart';


// Placeholder for SharedPreferencesService.
// In a real project, this class should be defined in the 'shared_services' package
// and exported from there. This local definition resolves the "Undefined class" error
// as per the instruction.
class SharedPreferencesService {
  Future<String?> getString(String key) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return null; // Or return a dummy value for testing
  }

  Future<bool> setString(String key, String value) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return true;
  }

  Future<bool> remove(String key) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return true;
  }
}

/// Sebuah [ChangeNotifier] yang memberitahu listener-nya setiap kali
/// status otentikasi pengguna berubah.
///
/// Ini digunakan oleh `GoRouter` dalam parameter `refreshListenable` untuk
/// memicu logika `redirect` secara otomatis saat login atau logout.
class AuthRedirectNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;
  AuthStatus _authStatus = AuthStatus.unauthenticated;
  final SharedPreferencesService _sharedPreferencesService;

  AuthRedirectNotifier(this._sharedPreferencesService) {
    _loadAuthStatus();
  }

  AuthStatus get value => _authStatus;

  Future<void> _loadAuthStatus() async {
    final token = await _sharedPreferencesService.getString('user_token');
    _isAuthenticated = token != null && token.isNotEmpty;
    _authStatus = _isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  void login() {
    _authStatus = AuthStatus.authenticating;
    notifyListeners();
    // Simulate API call or actual login process
    Timer(const Duration(seconds: 2), () async {
      await _sharedPreferencesService.setString('user_token', 'dummy_token');
      _isAuthenticated = true;
      _authStatus = AuthStatus.authenticated;
      notifyListeners();
    });
  }

  void logout() async {
    _authStatus = AuthStatus.authenticating;
    notifyListeners();
    // Simulate API call or actual logout process
    Timer(const Duration(seconds: 1), () async {
      await _sharedPreferencesService.remove('user_token');
      _isAuthenticated = false;
      _authStatus = AuthStatus.unauthenticated;
      notifyListeners();
    });
  }
}

enum AuthStatus {
  authenticated,
  unauthenticated,
  authenticating,
}
