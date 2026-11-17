import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/navigations/app_routes.dart';
import 'package:matrix_sphere/navigations/app_extractor.dart';


class AppShellRoute {
  /// Mengembalikan konfigurasi StatefulShellRoute untuk navigasi utama ber-tab.
  static RouteBase route({
    required GlobalKey<NavigatorState> rootNavigatorKey,
  }) {
    return StatefulShellRoute.indexedStack(
      
      // ====================================================================
      // 1. SHELL BUILDER
      // Fungsi ini bertugas membangun kerangka UI utama (misalnya Scaffold
      // yang memiliki BottomNavigationBar atau NavigationBar).
      // Parameter `navigationShell` digunakan untuk mengontrol perpindahan tab.
      // ====================================================================
      builder: (
        BuildContext context, 
        GoRouterState state, 
        StatefulNavigationShell navigationShell,
      ) {
        // [CONTOH PENERAPAN]:
        // return AppNavigator(navigationShell: navigationShell);
        
        // Kode sementara (Placeholder) agar tidak error sebelum AppNavigator dibuat:
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (int index) {
              // Berpindah ke tab tujuan berdasarkan indeks
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        );
      },

      // ====================================================================
      // 2. BRANCHES (appBranches)
      // Daftar cabang rute atau halaman yang menjadi isi dari masing-masing tab.
      // Setiap cabang memiliki rutenya sendiri secara terisolasi.
      // ====================================================================
      branches: <StatefulShellBranch>[
        
        // --- Branch Tab 1 (Contoh: Home) ---
        StatefulShellBranch(
          routes: [
            /*
            GoRoute(
              path: AppRoutes.home, // Pastikan path didefinisikan di app_routes.dart
              builder: (context, state) => const HomeScreen(),
            ),
            */
          ],
        ),

        // --- Branch Tab 2 (Contoh: Profil) ---
        StatefulShellBranch(
          routes: [
            
            GoRoute(
              path: AppRoutes.userProfile,
              builder: (context, state) => const UserProfileScreen(),
            ),
            GoRoute(
              path: AppRoutes.userEditProfile,
              builder: (context, state) => const EditProfileScreen(),
            ),
          ],
        ),
        
      ],
    );
  }
}