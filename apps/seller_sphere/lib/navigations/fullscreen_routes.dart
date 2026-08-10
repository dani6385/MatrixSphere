// lib/navigations/fullscreen_routes.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/features/auth/login_screen.dart';
//import 'package:seller_sphere/features/services/profiles/user/profile_screen.dart';
import 'app_routes.dart';

/// Membangun daftar rute yang ditampilkan di atas shell utama (tanpa BottomNavBar).
List<RouteBase> buildFullscreenRoutes(GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.login,
      parentNavigatorKey: rootNavigatorKey, // Penting agar rute ini tidak berada di dalam shell
      builder: (context, state) => const LoginScreen(),
    ),
    // Anda bisa menambahkan rute fullscreen lain di sini
    // Contoh:
    // GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
  ];
}