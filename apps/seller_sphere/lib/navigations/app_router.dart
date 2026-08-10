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
    // Menggunakan async untuk redirect karena getCurrentShopId adalah Future
    // Namun, GoRouter redirect tidak mendukung async secara langsung di sini.
    // Kita akan menggunakan FutureBuilder atau sejenisnya di root widget
    // atau memastikan _authService.isLoggedIn() dan _authService.getCurrentShopId()
    // sudah di-resolve sebelum redirect dievaluasi.
    // Untuk saat ini, kita akan asumsikan _authService.isLoggedIn() cukup cepat.
    // getCurrentShopId akan dipanggil secara sinkron di sini, yang mungkin
    // memblokir UI jika belum di-cache.

    final bool loggedIn = _authService.isLoggedIn();
    const String loginLocation = AppRoutes.login;
    const String registerLocation = AppRoutes.register;
    const String forgotPasswordLocation = AppRoutes.forgotPassword;
    const String shopRegisterLocation = AppRoutes.shopRegister;
    const String homeLocation = AppRoutes.home;

    final bool isLoggingIn = state.matchedLocation == loginLocation;
    final bool isRegistering = state.matchedLocation == registerLocation;
    final bool isForgotPassword = state.matchedLocation == forgotPasswordLocation;
    final bool isRegisteringShop = state.matchedLocation == shopRegisterLocation;

    // Jika pengguna belum login
    if (!loggedIn) {
      // Izinkan akses ke halaman login, register, dan forgot password
      if (isLoggingIn || isRegistering || isForgotPassword) {
        return null;
      }
      // Alihkan ke halaman login untuk rute lainnya
      return loginLocation;
    }

    // Jika pengguna sudah login
    // Periksa apakah toko sudah terdaftar (ini akan memblokir jika tidak di-cache)
    final String? shopId = _authService.getCurrentShopIdSync(); // Menggunakan versi sinkron
    final bool hasShop = shopId != null && shopId.isNotEmpty;

    // Jika pengguna sudah login dan mencoba mengakses halaman login, register, atau forgot password
    if (isLoggingIn || isRegistering || isForgotPassword) {
      return homeLocation; // Arahkan ke home
    }

    // Jika pengguna sudah login tetapi belum memiliki toko
    if (!hasShop) {
      // Izinkan akses ke halaman pendaftaran toko
      if (isRegisteringShop) {
        return null;
      }
      // Alihkan ke halaman pendaftaran toko untuk rute lainnya
      return shopRegisterLocation;
    }

    // Jika pengguna sudah login dan memiliki toko, dan mencoba mengakses halaman pendaftaran toko
    if (isRegisteringShop) {
      return homeLocation; // Arahkan ke home
    }

    // Jika tidak ada kondisi pengalihan, biarkan navigasi berlanjut
    return null;
  },
);
