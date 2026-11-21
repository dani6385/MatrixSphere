import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'app_extractor.dart';

List<RouteBase> fullScreen({
  required GlobalKey<NavigatorState> rootNavigatorKey,
}) {
  return <RouteBase>[
    // =========================================================================
    // 1. GRUP PROFIL & EDIT PROFIL (USER, COMPANY, SHOP)
    // =========================================================================
    /*GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.userProfile,
      name: 'userProfile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserProfileScreen(),
    ),*/
    GoRoute(
      path: AppRoutes.companyProfile,
      name: 'companyProfile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const CompanyProfile(),
    ),/*
    GoRoute(
      path: AppRoutes.shopProfile,
      name: 'shopProfile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      name: 'editProfile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const EditProfileScreen(),
    ),

    // =========================================================================
    // 2. PENGATURAN & FITUR OPERASIONAL LAYAR PENUH
    // =========================================================================
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),*/

    // =========================================================================
    // 3. RUTE TAMBAHAN (AKTIFKAN SAAT SCREEN SUDAH TERSEDIA)
    // =========================================================================
    /*
    GoRoute(
      path: AppRoutes.scanQr,
      name: 'scanQr',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: AppRoutes.simulation,
      name: 'simulation',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SimulationScreen(),
    ),
    GoRoute(
      path: AppRoutes.stream,
      name: 'stream',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final String streamId = state.uri.queryParameters['id'] ?? '';
        return StreamingScreen(streamId: streamId);
      },
    ),
    */
  ];
}

/// Alias kompatibilitas jika ada bagian kode lama yang masih memanggil
/// `buildFullscreenRoutes(rootNavigatorKey)`.
List<RouteBase> buildFullscreenRoutes(
  GlobalKey<NavigatorState> rootNavigatorKey,
) {
  return fullScreen(rootNavigatorKey: rootNavigatorKey);
}