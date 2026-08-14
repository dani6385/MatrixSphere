import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:shared_services/auth/shop_status.enum.dart' hide ShopService;
import 'package:collection/collection.dart';
import 'package:shared_services/shared_services.dart';
import 'app_extractor.dart';

//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:shared_services/shared_services.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final AuthService _authService = AuthService();
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  // ...
    redirect: (BuildContext context, GoRouterState state) async {
      final bool isLoggedIn = _authService.isLoggedIn();
      final ShopService shopService = ShopService();
      final String currentPath = state.matchedLocation;
  
      // ... (kode untuk pengguna yang belum login)
  
      // 2. Jika sudah login, cegah agar tidak bisa masuk ke halaman login/register lagi, lalu cek toko
      if (isLoggedIn) {
        // INI BAGIAN PENTINGNYA:
        // Jika pengguna sudah login dan saat ini berada di halaman login atau registrasi,
        // maka secara otomatis "lempar" atau arahkan mereka ke halaman beranda (home).
        if (currentPath == AppRoutes.login || currentPath == AppRoutes.userRegistration) {
          return AppRoutes.home; // <-- PENGALIHAN TERJADI DI SINI
        }
  
        // Setelah itu, ada logika tambahan untuk memeriksa status toko.
        // Jika toko belum disetujui, pengguna akan dilempar ke halaman registrasi toko.
        final String? shopStatusString = await shopService.getCurrentShopId(_authService.currentUser);
        final ShopStatus? shopStatusEnum = shopStatusString != null
            ? ShopStatus.values.firstWhereOrNull((e) => e.name == shopStatusString)
            : null;
        final bool hasApprovedShop = shopStatusEnum == ShopStatus.approved;
        final bool isAtShopRegistration = state.matchedLocation == AppRoutes.shopRegistration;

        if (!hasApprovedShop && !isAtShopRegistration) {
          return AppRoutes.shopRegistration; // <-- PENGALIHAN LAINNYA
        }
        if (hasApprovedShop && isAtShopRegistration) {
          return AppRoutes.home;
        }
      }
      return null; // Jika tidak ada kondisi yang terpenuhi, jangan alihkan.
    },
  // ...
  
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
    /*buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),*/
  ],
);
