import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart'; // Sesuaikan jika nama file routes-mu berbeda
import '../auth/login_screen.dart';

// Import halaman login kamu di sini
// Contoh path import: import '../features/auth/login_screen.dart';
// import '../features/auth/login_screen.dart'; 

/// Fungsi untuk menghasilkan daftar rute autentikasi (Login, Register, dll)
List<RouteBase> buildAuthRoutes({required GlobalKey<NavigatorState> rootNavigatorKey}) {
  return [
    GoRoute(
      path: AppRoutes.login, // Menggunakan konstanta dari AppRoutes ('/login')
      parentNavigatorKey: rootNavigatorKey, // Memastikan tampil fullscreen tanpa bottom navbar
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
  ];
}
