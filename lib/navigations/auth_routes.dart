import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'app_routes.dart';

List<RouteBase> authRoutes({
  required GlobalKey<NavigatorState> rootNavigatorKey,
}) {
  return <RouteBase>[
    // Halaman masuk utama
    /*GoRoute(
      path: AppRoutes.login,
      name: 'login',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),

    // Halaman pilihan metode masuk (opsional)
    GoRoute(
      path: AppRoutes.loginOption,
      name: 'loginOption',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const LoginOptionScreen(),
    ),

    // Halaman lupa kata sandi
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Halaman pendaftaran pengguna baru
    GoRoute(
      path: AppRoutes.userRegistration,
      name: 'userRegistration',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserRegistrationScreen(),
    ),

    // Halaman pendaftaran toko / shop
    GoRoute(
      path: AppRoutes.shopRegistration,
      name: 'shopRegistration',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopRegistrationScreen(),
    ),

    // Halaman verifikasi email
    GoRoute(
      path: AppRoutes.verifyEmail,
      name: 'verifyEmail',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const VerifyEmailScreen(),
    ),

    // Halaman atur ulang kata sandi
    GoRoute(
      path: AppRoutes.resetPassword,
      name: 'resetPassword',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ResetPasswordScreen(),
    ),*/
  ];
}