
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
    final bool isLoggedIn = authService.isLoggedIn();
    final String currentPath = state.matchedLocation;

    // Izinkan akses bebas untuk halaman Login, Register, dan Forgot Password
    final bool isAuthRoute = currentPath == AppRoutes.login || 
                             currentPath == AppRoutes.register || 
                             currentPath == AppRoutes.forgotPassword;
    // Jika belum login dan tidak sedang di halaman auth, lempar ke login
    if (!isLoggedIn && !isAuthRoute) {
      return AppRoutes.login;
    }
    // 2. Jika sudah login, cegah agar tidak bisa masuk ke halaman login/register lagi, lalu cek toko
    if (isLoggedIn && isAuthRoute) {
        return '/';
    }
    final shopId = await authService.getCurrentShopId();
    final bool hasShop = shopId != null && shopId.isNotEmpty && shopId != 'toko_percobaan';
    final bool isRegisteringShop = currentPath == AppRoutes.shopRegistration;

    if (!hasShop && !isRegisteringShop) {
      return AppRoutes.shopRegistration;
    }
    return null; 
  },
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);