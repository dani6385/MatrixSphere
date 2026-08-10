// lib/features/auth/login/login_logic.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';

class LoginLogic {
  final AuthService _authService = AuthService();

  /// Memeriksa status login awal pengguna via Firebase
  Future<void> initSession({
    required void Function(bool isLoading) setLoading,
    required VoidCallback onLoggedIn,
  }) async {
    final isLoggedIn = _authService.isLoggedIn();
    if (isLoggedIn) {
      if (kDebugMode) {
        print('User is already logged in via Firebase. Navigating via GoRouter.');
      }
      onLoggedIn();
    } else {
      setLoading(false);
    }
  }

  /// Memproses fungsi login menggunakan Firebase
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required void Function(bool isLoading) setLoading,
  }) async {
    setLoading(true);

    try {
      await _authService.login(email, password);

      if (kDebugMode) {
        print('Login successful! Firebase user authenticated.');
      }
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      context.go(AppRoutes.home);
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString().replaceAll("Exception: ", "")}')),
      );
    } finally {
      setLoading(false);
    }
  }
}