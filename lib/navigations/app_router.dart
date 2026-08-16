import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/navigations/matrix_bottom_nav.dart';
import 'package:matrix_sphere/navigations/matrix_branches.dart';
import 'package:shared_navigations/shared_navigation.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home, // Langsung mulai dari halaman home
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
  routes: <RouteBase>[
    // StatefulShellRoute digunakan untuk membuat navigasi dengan shell (seperti BottomNavBar)
    // Di sini kita menggunakan helper `buildAppShellRoute` yang sudah Anda miliki
    buildAppShellRoute(
      // `shellBuilder` bertugas membangun UI shell (MatrixBottomNavBar)
      shellBuilder: (context, state, navigationShell) {
        return MatrixBottomNavBar(
          navigationShell: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            // `goBranch` adalah fungsi dari navigationShell untuk berpindah tab
            navigationShell.goBranch(index);
          },
        );
      },
      // `branches` berisi daftar rute/tab yang akan ditampilkan di dalam shell
      branches: matrixBranches,
    ),
  ],
);
