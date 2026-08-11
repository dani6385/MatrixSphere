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
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return const UserRegistrationScreen();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/shop-registration',
      builder: (context, state) {
        return const ShopRegistrationScreen();
      },
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const WindowsMapView(),
    ),
    GoRoute(
      path: '/user-profile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/shop-profile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopProfileScreen(
        shopId: '',
      ),
    ),
    GoRoute(
      path: '/order',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OrderScreen(),
    ),
    GoRoute(
      path: '/products/add',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ProductFormScreen(),
    ),
    GoRoute(
      path: '/scan-qr',
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/simulasi',
      builder: (context, state) => const SimulationScreen(),
    ),
    GoRoute(
      path: '/products/:productId', // Menggunakan parameter dinamis ID
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['productId']!;
        return ProductDetailScreen(
          productId: id,
          shopId: '',
        );
      },
    ),
    GoRoute(
      path: '/products/edit', // Menggunakan parameter dinamis ID untuk edit
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['productId']!;
        return ProductFormScreen(productId: id);
      },
    ),
  ];
}
