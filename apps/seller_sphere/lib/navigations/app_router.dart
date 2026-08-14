import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_contents/shared_contents.dart';
import 'package:shared_services/shared_services.dart';
import 'app_extractor.dart';

// Private navigator keys for each tab
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        final authStatus = context.read<AuthBloc>().state.status;
        final bool hasSeenOnboarding =
            SharedPrefsService.getBool(KeyConstants.hasSeenOnboarding) ??
                false;

        if (!hasSeenOnboarding) {
          return '/onboarding';
        }

        if (authStatus == AuthStatus.unauthenticated) {
          return '/login';
        }

        // If authenticated and has seen onboarding, proceed to home
        return '/home';
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),/*
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),*/
  ],
);
