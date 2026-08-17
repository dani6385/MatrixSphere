import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/navigations/app_routes.dart';
//import 'package:shared_services/auth/shop_status.enum.dart' hide ShopService;
//import 'package:shared_services/shared_services.dart';
//import 'package:collection/collection.dart'; // Import untuk firstWhereOrNull
import 'shell_route_config.dart';
//import 'auth_redirect_notifier.dart';
import 'fullscreen_routes.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Buat instance AuthService yang akan didengarkan oleh GoRouter
//final AuthService _authService = AuthService();

final GoRouter appRouter = GoRouter(
  // Kita mulai dari rute awal di salah satu branch, yaitu Home ('/')
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  // Daftarkan AuthService sebagai listener. GoRouter akan re-route saat ada notifikasi.
  // refreshListenable: AuthRedirectNotifier(), // Dinonaktifkan untuk skip login

  errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Halaman tidak ditemukan: ${state.error}'),
      ),
    ),
  redirect: (BuildContext context, GoRouterState state) async {
    // === LOGIKA OTENTIKASI DILEWATI UNTUK DEVELOPMENT ===
    // Cukup arahkan dari root ke home jika diperlukan, selain itu izinkan semua.
    final isAtRoot = state.matchedLocation == '/';
    if (isAtRoot) {
      return AppRoutes.home; // Pastikan selalu mulai dari home
    }
    return null; // Mengembalikan null berarti tidak ada pengalihan, izinkan akses.
    // =======================================================

    /* LOGIKA ASLI YANG DINONAKTIFKAN
    final bool isLoggedIn = _authService.isLoggedIn();
    final ShopService shopService = ShopService();
    final String currentPath = state.matchedLocation;

    // Izinkan akses bebas untuk halaman Login, Register, dan Forgot Password
    final bool isAuthRoute = currentPath == AppRoutes.login ||
        currentPath == AppRoutes.userRegistration ||
        currentPath == AppRoutes.forgotPassword;
    // Jika belum login dan tidak sedang di halaman auth, lempar ke login
    if (!isLoggedIn && !isAuthRoute) {
      return AppRoutes.login;
    }
    // 2. Jika sudah login, cegah agar tidak bisa masuk ke halaman login/register lagi, lalu cek toko
    if (isLoggedIn) {
      // Jika sudah login dan mencoba akses halaman login/register, lempar ke home.
      if (isAuthRoute) {
        return AppRoutes.home;
      }

      final shopStatus = await shopService.getShopStatus();
      final hasApprovedShop = shopStatus == ShopStatus.approved;

      // Cek apakah sedang berada di salah satu halaman registrasi toko
      final isAtShopRegistration = [AppRoutes.shopRegistration, AppRoutes.shopStatus, AppRoutes.shopSuccess]
          .contains(currentPath);

      // Jika toko belum disetujui (status 'none' atau 'pending') dan tidak sedang di halaman registrasi,
      // paksa arahkan ke halaman registrasi/status.
      if (!hasApprovedShop && !isAtShopRegistration) {
        return AppRoutes.shopRegistration;
      }
      // Jika toko sudah disetujui tapi mencoba akses halaman registrasi, kembalikan ke home.
      if (hasApprovedShop && isAtShopRegistration) {
        return AppRoutes.home;
      }
    }
    return null;
    */
  },
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);
