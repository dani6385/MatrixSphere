import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:collection/collection.dart';
import 'package:shared_services/auth/shop_status.enum.dart';
import 'package:shared_services/shared_services.dart' hide ShopService;
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
  redirect: (BuildContext context, GoRouterState state) async {
    final bool isLoggedIn = _authService.isLoggedIn();
    final String currentPath = state.uri.path;

    final bool onAuthRoute = currentPath == AppRoutes.login ||
        currentPath == AppRoutes.userRegistration;

    // 1. Logika untuk pengguna yang belum login
    if (!isLoggedIn) {
      // Jika belum login dan mencoba mengakses halaman selain onboarding, login, atau registrasi,
      // arahkan ke halaman login.
      if (currentPath != '/' && !onAuthRoute) {
        // Anda mungkin ingin mengizinkan beberapa halaman publik lainnya di sini.
        return AppRoutes.login;
      }
      return null; // Izinkan akses ke '/', '/login', '/user-registration'
    }

    // 2. Logika untuk pengguna yang sudah login
    // Jika sudah login dan mencoba mengakses halaman login/registrasi, arahkan ke home.
    if (onAuthRoute) {
      return AppRoutes.home;
    }

    // 3. Cek status toko untuk pengguna yang sudah login
    final ShopService shopService = ShopService();
    final String? shopStatusString =
        await shopService.getCurrentShopId(_authService.currentUser);
    final ShopStatus? shopStatus = shopStatusString != null
        ? ShopStatus.values.firstWhereOrNull((e) => e.name == shopStatusString)
        : null;

    final bool hasApprovedShop = shopStatus == ShopStatus.approved;
    final bool onShopRegistrationRoute = currentPath == AppRoutes.shopRegistration;

    // Jika toko belum disetujui dan pengguna tidak sedang di halaman registrasi toko, arahkan ke sana.
    if (!hasApprovedShop && !onShopRegistrationRoute) {
      return AppRoutes.shopRegistration;
    }

    // Jika toko sudah disetujui dan pengguna masih di halaman registrasi toko, arahkan ke home.
    if (hasApprovedShop && onShopRegistrationRoute) {
      return AppRoutes.home;
    }

    return null; // Tidak ada pengalihan yang diperlukan
  },
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
    /*buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),*/
  ],
);
