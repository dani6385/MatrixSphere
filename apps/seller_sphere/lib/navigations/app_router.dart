import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigation.dart' hide AuthGuard;
import 'package:shared_services/shared_services.dart' hide ShopService;
import 'package:shared_core/shared_core.dart';
import 'app_extractor.dart';

//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:seller_sphere/faeatures/auth/registrations/shop_registration_screen.dart'; // Contoh, sesuaikan path
//import 'package:seller_sphere/faeatures/auth/registrations/user_registration_screen.dart'; // Contoh, sesuaikan path

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final AuthService _authService = AuthService();
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  // Daftarkan AuthService sebagai listener. GoRouter akan re-route saat ada notifikasi.
  refreshListenable: _authService,
  redirect: (context, state) => AuthGuard.checkRedirect(context, state),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.userRegistration, // Contoh: '/user-registration'
      builder: (BuildContext context, GoRouterState state) {
        // Ganti dengan widget layar registrasi pengguna Anda
        return const Scaffold(body: Center(child: Text('User Registration')));
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.shopRegistration, // Contoh: '/shop-registration'
      builder: (BuildContext context, GoRouterState state) {
        // Ganti dengan widget layar registrasi toko Anda
        return const Scaffold(body: Center(child: Text('Shop Registration')));
      },
    ),
    //buildAppShellRoute(),
    //...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);
