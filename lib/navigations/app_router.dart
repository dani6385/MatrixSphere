import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_navigator.dart';
import 'app_branches.dart';
import 'package:shared_navigations/shared_navigations.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// StreamListenable untuk memantau perubahan status autentikasi
final _authChanges = GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges());

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login, // Kita arahkan eksplisit ke login dulu
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  refreshListenable: _authChanges,
  
  // SEMENTARA DIMATIKAN UNTUK WEB (Mencegah stuck di splash screen)
  // observers: [
  //   analyticsService.analitycsObserver,
  // ],
  
  redirect: (BuildContext context, GoRouterState state) {
    // ========================================================
    // [!] TESTING BYPASS: 
    // Logika Firebase Auth dimatikan sementara agar Anda bisa
    // masuk ke halaman utama tanpa di-block oleh router.
    // ========================================================
    
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool isLoggingIn = state.matchedLocation == '/login';

    if (!loggedIn && !isLoggingIn) {
      return AppRoutes.login;
    }
    if (loggedIn && isLoggingIn) {
      return AppRoutes.home;
    }
    

    return null; // Membiarkan navigasi bebas berjalan
  },
  
  errorBuilder: (context, state) {
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
                onPressed: () => GoRouter.of(context).go('/login'),
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
      branches: appBranches,
    ),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);