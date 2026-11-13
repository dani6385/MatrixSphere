import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'app_extractor.dart';
import 'package:matrix_sphere/auth/auth_gate.dart';

/// Membangun rute fullscreen untuk modul autentikasi menggunakan shared_screens.
List<RouteBase> buildAuthRoutes({GlobalKey<NavigatorState>? rootNavigatorKey}) {
  return [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.authGate,
      name: 'auth_gate',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AuthGate(),
    ),
  ];
}
