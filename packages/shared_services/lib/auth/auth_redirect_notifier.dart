// d:\matrixsphere\apps\seller_sphere\lib\navigations\auth_redirect_notifier.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; // Pastikan import AuthService dari sini

class AuthRedirectNotifier extends ChangeNotifier {
  final AuthService _authService;
  AuthStatus _authStatus = AuthStatus.unauthenticated;

  // Sekarang hanya menerima satu parameter: AuthService
  AuthRedirectNotifier(this._authService) {
    _loadAuthStatus();
  }

  AuthStatus get value => _authStatus;

  Future<void> _loadAuthStatus() async {
    // Menggunakan fungsi yang ada di dalam AuthService untuk mengecek status
    final bool isLoggedIn = _authService.isLoggedIn(); 
    _authStatus = isLoggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  // Kamu bisa menambahkan metode login/logout yang memanggil _authService
  void updateStatus(bool isLoggedIn) {
    _authStatus = isLoggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }
}

enum AuthStatus {
  authenticated,
  unauthenticated,
  authenticating,
}