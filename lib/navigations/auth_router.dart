import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
// Sesuaikan path import ini dengan lokasi file halaman LoginScreens milikmu
import 'package:matrix_sphere/auth/login_screen.dart';

class AuthRouter {
  /// Mengembalikan daftar rute khusus untuk fitur Autentikasi (Login, Register, dll).
  /// Parameter [rootNavigatorKey] memastikan halaman ditampilkan di atas navigator utama.
  static List<RouteBase> routes({
    required GlobalKey<NavigatorState> rootNavigatorKey,
  }) {
    return [
      GoRoute(
        path: AppRoutes.login, // Mengarah ke path '/login' sesuai definisi di AppRoutes
        name: 'login',
        parentNavigatorKey: rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          // Mengarahkan langsung ke widget LoginScreens milikmu
          return const LoginScreen();
        },
      ),
      
      // Kamu bisa menambahkan rute autentikasi lainnya di bawah ini nanti,
      // misalnya untuk halaman Register atau Lupa Password.
    ];
  }
}