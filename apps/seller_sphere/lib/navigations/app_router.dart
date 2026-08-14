
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:shared_navigations/shared_navigation.dart';
import 'app_extractor.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:shared_services/shared_services.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    return null; // Placeholder for redirect logic
  },
);