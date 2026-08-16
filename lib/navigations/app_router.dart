import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'matrix_branches.dart';
import 'matrix_bottom_nav.dart';
//import 'package:shared_services/shared_services.dart';
import 'package:shared_navigations/shared_navigation.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  //refreshListenable: AuthRedirectNotifier(),

  // Tambahkan redirect untuk menangani rute awal
  redirect: (BuildContext context, GoRouterState state) {
    // Jika pengguna berada di rute root ('/'), arahkan ke halaman home.
    if (state.uri.toString() == '/') {
      return AppRoutes.home; // Asumsi AppRoutes.home adalah '/home'
    }
    // Jika tidak, jangan lakukan pengalihan.
    return null;
  },

  // 1. Observer analitik dinonaktifkan untuk sementara
  // observers: [
  //   analyticsService.analitycsObserver,
  // ],
  errorBuilder: (context, state) {
    // 2. Pelaporan error navigasi ke Crashlytics dinonaktifkan untuk sementara
    // crashlyticsService.recordError(
    //   state.error ?? 'GoRouter Navigation Error',
    //   StackTrace.current,
    //   reason: 'Kesalahan Navigasi GoRouter di path: ${state.uri.toString()}',
    // );

    // Tampilkan halaman error yang informatif kepada pengguna
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
                'Halaman yang Anda tuju tidak dapat ditemukan.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context
                    .go(AppRoutes.home), // Arahkan kembali ke halaman utama
                child: const Text('Kembali ke Home'),
              ),
            ],
          ),
        ),
      ),
    );
  },
  routes: [
    buildAppShellRoute(
      shellBuilder: (context, state, navigationShell) {
        // Di sini kamu masukkan BottomNavBar khusus Matrix Sphere
        return MatrixBottomNavBar(
          navigationShell: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(index);
          },
        );
      },
      branches: bottomBranches, // Menggunakan matrixBranches yang benar
    ),
  ],
);
