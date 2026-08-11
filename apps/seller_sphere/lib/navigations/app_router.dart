
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:shared_services/auth/auth_service.dart';
import 'shell_route_config.dart';
import 'fullscreen_routes.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  // Kita mulai dari rute awal di salah satu branch, yaitu Home ('/')
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  redirect: (BuildContext context, GoRouterState state) async {
    final AuthService authService = AuthService();
    
    // 1. Cek apakah pengguna sudah login
    final bool isLoggedIn = authService.isLoggedIn();
    
    // Mengecek apakah rute saat ini adalah halaman login
    final bool isLoggingIn = state.matchedLocation == AppRoutes.login;

    // Jika belum login dan tidak sedang berada di halaman login, arahkan ke login
    if (!isLoggedIn && !isLoggingIn) {
      return AppRoutes.login;
    }

    // Jika sudah login, cek apakah sudah memiliki toko (syarat lanjutan)
    if (isLoggedIn) {
      final shopId = await authService.getCurrentShopId();
      final bool hasShop = shopId != null && shopId.isNotEmpty && shopId != 'toko_percobaan';
      
      final bool isRegisteringShop = state.matchedLocation == AppRoutes.shopRegistration;

      // Jika belum punya toko dan sedang tidak di halaman registrasi toko, arahkan ke pendaftaran toko
      if (!hasShop && !isRegisteringShop) {
        return AppRoutes.shopRegistration;
      }
    }

    // Jika aman, izinkan melanjutkan perjalanan ke rute tujuan
    return null; 
  },
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);