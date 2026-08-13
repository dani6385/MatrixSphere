
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';

class RouteGenerator {
  static GoRouter getRouter({
    required AuthRedirectNotifier authRedirectNotifier,
    required List<GoRoute> routes,
    List<NavigatorObserver>? observers,
    String? initialLocation,
    String? redirectLocation,
    bool debugLogDiagnostics = false,
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      debugLogDiagnostics: debugLogDiagnostics,
      observers: observers,
      routes: routes,
      refreshListenable: authRedirectNotifier,
      redirect: (BuildContext context, GoRouterState state) {
        
        final bool isAuthenticated = authRedirectNotifier.value == AuthStatus.authenticated;
        final bool isUnauthenticated = authRedirectNotifier.value == AuthStatus.unauthenticated;
        final bool isAuthenticating = authRedirectNotifier.value == AuthStatus.authenticating;

        final bool isGoingToAuth = state.matchedLocation == redirectLocation;

        // If not authenticated and not going to auth, redirect to auth
        if (isUnauthenticated && !isGoingToAuth) {
          return redirectLocation;
        }

        // If authenticated and going to auth, redirect to initial location
        if (isAuthenticated && isGoingToAuth) {
          return initialLocation;
        }

        // If authenticating, stay on the current page
        if (isAuthenticating) {
          return null;
        }
        return null;

        // No redirect needed        return null;
      },
    );
  }
}
