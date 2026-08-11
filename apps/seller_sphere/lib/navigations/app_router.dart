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
  refreshListenable: GoRouterRefreshStream(_authService.authStateChanges),
  initialLocation: AppRoutes.home,
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
  redirect: (BuildContext context, GoRouterState state) async {
    const String loginLocation = AppRoutes.login;
    const String registerLocation = AppRoutes.register;
    const String forgotPasswordLocation = AppRoutes.forgotPassword;
    const String homeLocation = AppRoutes.home;

    final bool isLoggingIn = state.matchedLocation == loginLocation;
    final bool isRegistering = state.matchedLocation == registerLocation;
    final bool isForgotPassword = state.matchedLocation == forgotPasswordLocation;

    final bool loggedIn = _authService.isLoggedIn();

    // Jika pengguna belum login
    if (!loggedIn) {
      // Izinkan akses ke halaman login, register, dan forgot password
      return (isLoggingIn || isRegistering || isForgotPassword) ? null : loginLocation;
    }

    // Jika pengguna sudah login
    // Jika pengguna sudah login dan mencoba mengakses halaman login, register, atau forgot password
    if (isLoggingIn || isRegistering || isForgotPassword) {
      return homeLocation; // Arahkan ke home
    }

    // Jika tidak ada kondisi pengalihan, biarkan navigasi berlanjut
    return null;
  },
);

/// Stream wrapper untuk digunakan dengan GoRouter's refreshListenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}
