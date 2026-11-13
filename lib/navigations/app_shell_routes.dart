// Simpan file ini di direktori navigasi Anda, contoh: lib/navigations/app_shell_route.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Impor custom bottom navbar yang sudah kita buat sebelumnya di shared_ui
// import '../shared_ui/custom_bottom_navbar.dart';

/// Fungsi pembangun ShellRoute untuk kerangka utama aplikasi (Bottom Navbar konsisten)
RouteBase buildAppShellRoute({
  required List<StatefulShellBranch> branches,
  required shellBuilder,
}) {
  return ShellRoute(
    builder: (BuildContext context, GoRouterState state, Widget child) {
      return Scaffold(
        body: child, // Menampilkan halaman anak sesuai rute aktif
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF00E5FF), // Sesuaikan dengan tema navbar Anda
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () => context.go('/'), // Rute Home
              ),
              IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                onPressed: () => context.go('/approvals'), // Rute Approvals
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart, color: Colors.white),
                onPressed: () => context.go('/analytics'), // Rute Analytics
              ),
              IconButton(
                icon: const Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                ),
                onPressed: () =>
                    context.go('/transactions'), // Rute Transactions
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onPressed: () =>
                    context.go('/user-profile'), // Rute User Profile
              ),
            ],
          ),
        ),
      );
    },
    routes: <RouteBase>[
      // Daftar rute anak yang akan dirender di dalam kerangka ShellRoute ini
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Center(child: Text('Home Screen Content')),
      ),
      GoRoute(
        path: '/approvals',
        builder: (context, state) =>
            const Center(child: Text('Approvals Screen')),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) =>
            const Center(child: Text('Analytics Screen')),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) =>
            const Center(child: Text('Transactions Screen')),
      ),
      GoRoute(
        path: '/user-profile',
        builder: (context, state) =>
            const Center(child: Text('User Profile Screen')),
      ),
    ],
  );
}
