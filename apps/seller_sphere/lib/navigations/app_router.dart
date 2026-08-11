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
    final bool loggedIn = _authService.isLoggedIn();

    // Daftar rute yang tidak memerlukan otentikasi
    final unauthenticatedRoutes = [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.forgotPassword,
    ];

    final isGoingToUnauthenticatedRoute = unauthenticatedRoutes.contains(state.matchedLocation);

    // Jika pengguna sudah login dan mencoba mengakses halaman login/register,
    // alihkan ke halaman utama.
    if (loggedIn && isGoingToUnauthenticatedRoute) {
      return AppRoutes.home;
    }

    // Jika pengguna belum login dan mencoba mengakses halaman yang dilindungi,
    // alihkan ke halaman login.
    if (!loggedIn && !isGoingToUnauthenticatedRoute) {
      return AppRoutes.login;
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
