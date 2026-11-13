import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'app_extractor.dart';

List<RouteBase> buildFullscreenRoutes(
    GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.userProfile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserProfileScreen(),
    ),
    /*GoRoute(
      path: AppRoutes.shopProfile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.scanQr,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ScannerScreen(),
    ),*/
  ];
}


