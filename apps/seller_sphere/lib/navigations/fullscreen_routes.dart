// lib/navigations/fullscreen_routes.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_extractor.dart';
import 'app_routes.dart';
import 'auth_routes.dart';

/// Membangun daftar rute yang ditampilkan di atas shell utama (tanpa BottomNavBar).
List<RouteBase> buildFullscreenRoutes(
    GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    // Menggabungkan semua rute otentikasi dari file auth_routes.dart
    ...buildAuthRoutes(rootNavigatorKey),

    // Rute fullscreen lainnya yang tidak terkait dengan otentikasi
    GoRoute(
      path: AppRoutes.shopRegister,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopRegistrationScreen(),
    ),
  ];
}
