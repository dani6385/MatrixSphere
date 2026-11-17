// lib/navigations/full_screen_route.dart

import 'package:go_router/go_router.dart';

import 'package:matrix_sphere/navigations/app_routes.dart';
import 'app_extractor.dart';

/// Daftar rute full screen (di luar shell branches / bottom navigation bar)
List<RouteBase> getFullScreen() {
  return [
    // Halaman Profil Pengguna
    GoRoute(
      path: AppRoutes.userProfile,
      builder: (context, state) => const UserProfileScreen(),
      routes: [
        // Sub-rute untuk Edit Profil: /user-profile/edit
        GoRoute(
          path: AppRoutes.userEditProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),
      ],
    ),
  ];
}