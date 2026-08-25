import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_navigator.dart';
import 'app_branches.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_navigations/shared_navigations.dart';

//import 'shell_route_config.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  //refreshListenable: AuthRedirectNotifier(),
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
                onPressed: () => AppNavigation.goToLogin(context),
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
        return AppNavigator(navigationShell: navigationShell);
      },
      branches: appBranches, // Daftar cabang rute khusus Matrix
    ),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);

