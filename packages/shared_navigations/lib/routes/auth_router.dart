// Disimpan di packages/shared_navigation/lib/routes/app_shell_branches.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<StatefulShellBranch> authShellBranches({
  required Widget loginScreen, // Contoh: Home / Beranda
  required Widget regitrationScreen, // Contoh: Approvals (Matrix) atau Financial (Seller)
  required Widget forgotScreen, // Contoh: Analytics (Matrix) atau Management (Seller)
  GlobalKey<NavigatorState>? homeNavigatorKey,
  
}) {
  return [
    // Branch untuk Tab Home
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => loginScreen,
        ),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: '/regitration',
          builder: (context, state) => regitrationScreen,
        ),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: '/forgot',
          builder: (context, state) => forgotScreen,
        ),
      ],
    ),
  ];
}
