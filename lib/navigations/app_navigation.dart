import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
/// Ekstensi kustom untuk mempercepat navigasi menggunakan GoRouter
extension AppNavigation on BuildContext {
  /// Berpindah ke halaman profil
  void goToProfile() => go(AppRoutes.profile);
  /// Berpindah ke halaman beranda
  void goToHome(BuildContext context) => go(AppRoutes.home);
  /// Berpindah ke halaman pengaturan
  void goToSettings() => go(AppRoutes.settings);
  /// Berpindah ke halaman login
  void goToLogin() => go(AppRoutes.login);
}