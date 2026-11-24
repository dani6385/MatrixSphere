import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_services/shared_services.dart';
import 'app_branches.dart';
import 'app_navigator.dart';
import 'app_routes.dart';
import 'fullscreen_routes.dart';
import 'auth_routes.dart';
import 'refresh_stream.dart';
import 'shell_route.dart';

/// Logger global untuk memantau alur navigasi dan redirect di terminal.
final Logger logger = Logger();

/// Kunci global untuk navigator utama (root).
/// Dibuat publik (tanpa garis bawah) agar bisa dipakai oleh rute fullscreen
/// seperti ShopProfileScreen melalui `parentNavigatorKey: rootNavigatorKey`.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Mendengarkan perubahan status login/logout dari FirebaseAuth
/// agar GoRouter otomatis mengevaluasi ulang fungsi `redirect`.
final RefreshStream _authChanges = RefreshStream(
  FirebaseAuth.instance.authStateChanges(),
);

/// Konfigurasi utama GoRouter untuk aplikasi Matrix Sphere.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  debugLogDiagnostics: true,
  navigatorKey: rootNavigatorKey,
  refreshListenable: _authChanges,
  observers: [analyticsService.observer],

  // Pengecekan akses otomatis setiap kali rute berubah atau status auth berubah
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool isLoggingIn = state.matchedLocation == AppRoutes.login;

    logger.i(
      '--- REDIRECT CHECK --- LoggedIn: $loggedIn | Location: ${state.matchedLocation}',
    );

    // Jika belum login dan mencoba membuka halaman selain login -> arahkan ke login
    if (!loggedIn && !isLoggingIn) {
      return AppRoutes.login;
    }

    // Jika sudah login tapi masih berada di halaman login -> arahkan ke home
    if (loggedIn && isLoggingIn) {
      return AppRoutes.home;
    }

    // Biarkan navigasi berjalan normal
    return null;
  },

  // Tampilan cadangan jika pengguna membuka alamat path yang tidak terdaftar
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Oops! Terjadi kesalahan navigasi.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Path yang error: ${state.uri.toString()}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Kembali ke Home'),
              ),
            ],
          ),
        ),
      ),
    );
  },

  // Daftar seluruh rute aplikasi
  routes: [
    // 1. Rute autentikasi (Login, Register, dll.)
    ...authRoutes(rootNavigatorKey: rootNavigatorKey),

    // 2. Cangkang navigasi utama (Bottom Navbar + Drawer di AppNavigator)
    shellRoute(
      shellBuilder: (context, state, navigationShell) {
        return AppNavigator(navigationShell: navigationShell);
      },
      branches: appBranches,
    ),

    // 3. Rute layar penuh di atas rootNavigatorKey (misal: shopProfile)
    ...fullScreen(rootNavigatorKey: rootNavigatorKey),
  ],
);