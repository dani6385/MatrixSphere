import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_screens/shared_screens.dart';
import 'app_routes.dart';

List<RouteBase> buildFullscreenRoutes(
    GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.login,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.userRegistration,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserRegistrationScreen(),
    ),
    GoRoute(
      path: AppRoutes.shopRegistration,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopRegistrationScreen(),
    ),
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

