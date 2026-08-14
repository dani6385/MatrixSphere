import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:shared_navigations/shared_navigation.dart';
import 'app_extractor.dart';

//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:shared_services/shared_services.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
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
