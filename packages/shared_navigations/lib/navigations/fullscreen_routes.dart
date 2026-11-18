import 'package:go_router/go_router.dart';
import 'package:shared_navigations/navigations/app_routes.dart';
import 'package:shared_navigations/shared_navigations.dart';
import 'package:shared_screens/shared_screens.dart';// lib/navigations/full_screen_route.dart

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
          path: 'edit',
          builder: (context, state) => const EditProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.companyProfile,
      builder: (context, state) => const CompanyProfile(),
      routes: [
        // Sub-rute untuk Edit Profil: /company-profile/edit
        GoRoute(
          path: 'edit',
          builder: (context, state) => const EditCompanyProfile(),
        ),
      ],
    ),
    /*GoRoute(
      path: AppRoutes.manageUsers,
      builder: (context, state) => const AdminScreen(),
    ),*/
  ];
}
