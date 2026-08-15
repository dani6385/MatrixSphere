import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shell_route_config.dart';
import 'auth_redirect_notifier.dart';
import 'fullscreen_routes.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  // Kita mulai dari rute awal di salah satu branch, yaitu Home ('/')
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  // Daftarkan AuthService sebagai listener. GoRouter akan re-route saat ada notifikasi.
  refreshListenable: AuthRedirectNotifier(),
  errorBuilder: (context, state) {
    // 1. Log error ke konsol debug untuk pengembangan
    debugPrint('Kesalahan Navigasi GoRouter: ${state.error}');

    // 2. Kirim error ke Firebase Crashlytics
    FirebaseCrashlytics.instance.recordError(
      state.error,
      state.error != null ? StackTrace.current : null,
      reason: 'Kesalahan Navigasi GoRouter di path: ${state.uri.toString()}',
      fatal: false, // false karena aplikasi tidak langsung crash
    );

    // 3. Tampilkan halaman error yang informatif kepada pengguna
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
                onPressed: () => context.go('/'), // Arahkan kembali ke halaman utama
                child: const Text('Kembali ke Home'),
              ),
            ],
          ),
        ),
      ),
    );
  },
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);
