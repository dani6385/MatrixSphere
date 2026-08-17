import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_branches.dart';
import 'bottom_nav_bar.dart';

import 'package:shared_services/shared_services.dart';
import 'package:shared_navigations/shared_navigation.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  redirect: (context, state) {
    // Jika rute yang diakses adalah root ('/'), arahkan secara aman ke halaman utama Anda
    if (state.uri.toString() == '/') {
      return '/home'; // Pastikan path '/home' ada di salah satu branch Anda
    }
    return null; // Lanjutkan navigasi normal jika bukan '/'
  },
  observers: [
    analyticsService.analitycsObserver,
  ],
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
                onPressed: () => context.go(AppRoutes.home),
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
      // === DEBUG: Melewati BottomNavBar untuk sementara ===
      // Daripada membuat widget BottomNavBar, kita langsung tampilkan konten halaman (navigationShell).
      // Ini untuk mengisolasi masalah.
      shellBuilder: (context, state, navigationShell) {
        // Jika halaman sekarang muncul, maka masalahnya ada di dalam widget BottomNavBar.
        // Jika masih abu-abu, masalahnya ada di konfigurasi branch atau halaman itu sendiri.
        return navigationShell;
      },
      branches: appBranches,
    ),
  ],
);
