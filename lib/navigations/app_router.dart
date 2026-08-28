import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <-- Tambahkan import ini

import 'app_navigator.dart';
import 'app_branches.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_navigations/shared_navigations.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// StreamListenable untuk memantau perubahan status autentikasi
final _authChanges = GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges());

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  // Aktifkan kembali refreshListenable untuk mereaksi perubahan login/logout
  refreshListenable: _authChanges,
  observers: [
    analyticsService.analitycsObserver,
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;

    // Asumsi rute login adalah '/login'. Sesuaikan jika berbeda.
    // Rute ini didefinisikan di dalam `buildAuthRoutes`.
    final bool isLoggingIn = state.matchedLocation == '/login';

    // 1. Jika pengguna TIDAK login dan TIDAK sedang menuju halaman login,
    //    maka paksa arahkan ke halaman login.
    if (!loggedIn && !isLoggingIn) {
      return '/login';
    }

    // 2. Jika pengguna SUDAH login dan mencoba mengakses halaman login,
    //    maka arahkan mereka ke halaman utama ('/').
    if (loggedIn && isLoggingIn) {
      return '/';
    }

    // 3. Jika tidak ada kondisi di atas, jangan lakukan redirect (lanjutkan).
    return null;
  },
  errorBuilder: (context, state) {
    crashlyticsService.recordError(
      state.error ?? 'GoRouter Navigation Error',
      StackTrace.current,
      reason: 'Kesalahan Navigasi GoRouter di path: ${state.uri.toString()}',
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Oops! Terjadi kesalahan.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Halaman yang Anda tuju tidak dapat ditemukan. Kami telah mencatat error ini dan akan segera memperbaikinya.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).go('/login'), // Arahkan ke login
                child: const Text('Kembali ke Login'),
              ),
            ],
          ),
        ),
      ),
    );
  },
  routes: [
    ...buildAuthRoutes(rootNavigatorKey: _rootNavigatorKey),
    buildAppShellRoute(
      shellBuilder: (context, state, navigationShell) {
        // Shell ini sekarang hanya akan dibangun jika pengguna sudah login,
        // berkat logic di `redirect`.
        return AppNavigator(navigationShell: navigationShell,);
      },
      branches: appBranches, // Daftar cabang rute khusus Matrix
    ),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);
