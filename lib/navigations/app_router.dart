// app_router.dart
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
  
  // 1. NONAKTIFKAN refreshListenable agar tidak diredirect ke halaman login
  // refreshListenable: AuthRedirectNotifier(),

  // 2. (Opsional) Jika ada fungsi redirect otentikasi di bawah, Anda bisa menonaktifkannya juga:
  // redirect: (context, state) {
  //   // Logika pengecekan login dilewati sementara
  //   return null; 
  // },

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
      shellBuilder: (context, state, navigationShell) {
        return BottomNavBar(
          navigationShell: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(index);
          },
        );
      },
      branches: appBranches,
    ),
  ],
);