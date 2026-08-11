
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'app_routes.dart';
import 'auth_redirect_notifier.dart';
import 'shell_route_config.dart';
import 'fullscreen_routes.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Notifier untuk mendengarkan perubahan status otentikasi
final _authNotifier = AuthRedirectNotifier();

/// Logika pengalihan (redirect) untuk GoRouter.
/// Fungsi ini akan dieksekusi setiap kali ada navigasi atau saat `refreshListenable` memberitahu.
String? _authRedirect(BuildContext context, GoRouterState state) {
  final authService = AuthService();
  final isLoggedIn = authService.isLoggedIn();
  final location = state.matchedLocation;

  // Daftar rute yang dapat diakses publik (tanpa login)
  final publicRoutes = [
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
  ];

  // Jika pengguna belum login dan mencoba mengakses rute yang dilindungi
  if (!isLoggedIn && !publicRoutes.contains(location)) {
    return AppRoutes.login; // Alihkan ke halaman login
  }

  // Jika pengguna sudah login dan mencoba mengakses halaman login
  if (isLoggedIn && location == AppRoutes.login) {
    return AppRoutes.home; // Alihkan ke halaman utama
  }

  // Jika tidak ada kondisi di atas, izinkan navigasi (jangan alihkan)
  return null;
}

final GoRouter appRouter = GoRouter(
  // Kita mulai dari rute awal di salah satu branch, yaitu Home ('/')
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  // refreshListenable akan membuat GoRouter mengevaluasi ulang rute
  // setiap kali _authNotifier memanggil notifyListeners() (yaitu saat status auth berubah).
  refreshListenable: _authNotifier,
  // redirect akan menjalankan logika di atas pada setiap navigasi.
  redirect: _authRedirect,
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);