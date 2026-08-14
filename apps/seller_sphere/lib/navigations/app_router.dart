import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:shared_services/auth/shop_status.enum.dart';
import 'package:collection/collection.dart';
import 'package:shared_services/shared_services.dart' hide ShopService;
import 'fullscreen_routes.dart';
import 'shell_route_config.dart';


// Private navigator keys for each tab
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final AuthService _authService = AuthService();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  refreshListenable: AuthRedirectNotifier(
      _authService), // Pastikan tipenya sesuai dengan konstruktor
  redirect: (BuildContext context, GoRouterState state) async {
    final String currentPath = state.matchedLocation;

    // 1. Cek Onboarding (Prioritas Utama)
    final bool hasSeenOnboarding =
        SharedPrefsService.getBool('hasSeenOnboarding') ?? false;
    if (!hasSeenOnboarding && currentPath != AppRoutes.onboarding) {
      return AppRoutes.onboarding as String;
    }

    final bool isLoggedIn = _authService.isLoggedIn();
    final bool isAuthRoute = currentPath == AppRoutes.login ||
        currentPath == AppRoutes.userRegistration ||
        currentPath == AppRoutes.forgotPassword;

    // 2. Redirect jika belum login
    if (!isLoggedIn) {
      return isAuthRoute ? null : AppRoutes.login;
    }

    // 3. Jika sudah login dan mencoba ke halaman auth, lempar ke home
    if (isAuthRoute) return AppRoutes.home;

    // 4. Cek Status Toko (Hanya jika sudah login)
    final ShopService shopService = ShopService();
    final String? shopStatusString =
        await shopService.getCurrentShopId(_authService.currentUser);
    final ShopStatus? shopStatusEnum =
        ShopStatus.values.firstWhereOrNull((e) => e.name == shopStatusString);

    final bool hasApprovedShop = shopStatusEnum == ShopStatus.approved;
    final bool isAtShopRegistration = currentPath == AppRoutes.shopRegistration;

    if (!hasApprovedShop && !isAtShopRegistration) {
      return AppRoutes.shopRegistration;
    }
    if (hasApprovedShop && isAtShopRegistration) {
      return AppRoutes.home;
    }

    return null; // Tidak ada redirect
  },
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);
