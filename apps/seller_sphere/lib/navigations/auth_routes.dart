// d:\matrixsphere\apps\seller_sphere\lib\navigations\auth_routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_extractor.dart';
import 'app_routes.dart';

/// Kumpulan rute yang terkait dengan otentikasi (login, register, dll).
/// Rute-rute ini tidak berada di dalam shell utama aplikasi (tanpa BottomNavBar).
List<RouteBase> buildAuthRoutes(GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.login,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const RegistrationScreen(),
    ),
  ];
}
