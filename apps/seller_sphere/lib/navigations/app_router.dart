import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'shell_route_config.dart';
import 'fullscreen_routes.dart';
import 'app_routes.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Instance dari AuthService untuk memeriksa status login
final AuthService _authService = AuthService();

final GoRouter appRouter = GoRouter(
  // Kita mulai dari rute awal di salah satu branch, yaitu Home ('/')
  initialLocation: AppRoutes.login,
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = _authService.isLoggedIn();
    const String loginLocation = AppRoutes.login;
    final bool isLoggingIn = state.matchedLocation == loginLocation;

    // Jika pengguna belum login dan tidak sedang di halaman login,
    // alihkan ke halaman login.
    if (!loggedIn && !isLoggingIn) {
      return loginLocation;
    }

    // Jika pengguna sudah login dan mencoba mengakses halaman login,
    // alihkan ke halaman utama.
    if (loggedIn && isLoggingIn) {
      return AppRoutes.home;
    }

    // Jika tidak ada kondisi di atas, jangan lakukan pengalihan.
    return null;
  },
);
