// lib/routes/fullscreen_routes.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'app_routes.dart';
import 'app_extractor.dart';
// Impor layar-layar terkait (pastikan jalurnya sesuai project-mu)

List<RouteBase> buildFullscreenRoutes(
    GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ];
}
