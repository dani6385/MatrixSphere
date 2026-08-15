import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_navigations/shared_navigation.dart' hide AuthGuard;
import 'package:shared_services/shared_services.dart';
import 'package:shared_core/shared_core.dart';
import 'app_extractor.dart';

// The correct AuthGuard implementation
class AuthGuard {
  static Future<String?> checkRedirect(BuildContext context, GoRouterState state) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final shopService = Provider.of<ShopService>(context, listen: false);

    final isAuthenticated = authService.isAuthenticated;
    final hasShop = await shopService.hasShop();

    final isLoginOrRegister =
        state.matchedLocation == '/login' ||
        state.matchedLocation == AppRoutes.userRegistration;
        
    final isShopRegistration = state.matchedLocation == AppRoutes.shopRegistration;

    // If the user is not authenticated
    if (!isAuthenticated) {
      // If they are already on login or registration, do nothing. Otherwise, redirect to login.
      return isLoginOrRegister ? null : '/login';
    }

    // If the user is authenticated but does not have a shop
    if (isAuthenticated && !hasShop) {
      // If they are not already on the shop registration page, redirect them.
      return isShopRegistration ? null : AppRoutes.shopRegistration;
    }

    // If the user is authenticated, has a shop, and is trying to access login/register
    if (isAuthenticated && hasShop && (isLoginOrRegister || isShopRegistration)) {
      // Redirect them to the home page.
      return '/home';
    }

    // In all other cases, no redirection is needed.
    return null;
  }
}


final _rootNavigatorKey = GlobalKey<NavigatorState>();
final AuthService _authService = AuthService(); 

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  refreshListenable: _authService,
  // The redirect now uses the locally defined AuthGuard
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
      path: AppRoutes.userRegistration, 
      builder: (BuildContext context, GoRouterState state) {
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
      path: AppRoutes.shopRegistration, 
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold(body: Center(child: Text('Shop Registration')));
      },
    ),
  ],
);
