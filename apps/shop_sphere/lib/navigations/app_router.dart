import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shop_branches.dart';
import 'shop_bottom_nav.dart';

import 'package:shared_services/shared_services.dart';
import 'package:shared_navigations/shared_navigation.dart';

//import 'shell_route_config.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  //refreshListenable: AuthRedirectNotifier(),
  redirect: (context, state) {
    // Jika rute yang diakses adalah root ('/'), arahkan secara aman ke halaman utama Anda
    if (state.uri.toString() == '/') {
      return '/home'; // Pastikan path '/home' ada di salah satu branch Anda
    }
    return null; // Lanjutkan navigasi normal jika bukan '/'
  },
  // 1. Tambahkan observer analitik di sini. Ini adalah lokasi yang benar.
  observers: [
    analyticsService.analitycsObserver,
  ],
  errorBuilder: (context, state) {
    // 2. Gunakan layanan terpusat untuk melaporkan error navigasi
    crashlyticsService.recordError(
      state.error ?? 'GoRouter Navigation Error',
      StackTrace.current,
      reason: 'Kesalahan Navigasi GoRouter di path: ${state.uri.toString()}',
    );

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
                'Halaman yang Anda tuju tidak dapat ditemukan. Kami telah mencatat error ini dan akan segera memperbaikinya.',
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
        return ShopBottomNavBar(
          navigationShell: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(index);
          },
        );
      },
      branches: shopBranches, // Daftar cabang rute khusus Matrix
    ),
  ],
);
