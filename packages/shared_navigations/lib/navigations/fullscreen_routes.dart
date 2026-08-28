import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/navigations/app_routes.dart';
import 'package:shared_navigations/shared_navigations.dart';
import 'package:shared_screens/shared_screens.dart';

List<RouteBase> buildFullscreenRoutes(
    GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.userProfile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.shopProfile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.scanQr,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ScannerScreen(),
    ),
  ];
}


