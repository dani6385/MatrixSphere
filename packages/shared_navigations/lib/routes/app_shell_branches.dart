// Disimpan di packages/shared_navigation/lib/routes/app_shell_branches.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<StatefulShellBranch> buildSharedShellBranches({
  required Widget homeScreen,
  required Widget approvalsScreen,
  required Widget analyticsScreen,
  required Widget transactionsScreen,
  required Widget attendanceScreen,
  GlobalKey<NavigatorState>? homeNavigatorKey,
}) {
  return [
    // Branch untuk Tab Home
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => homeScreen,
        ),
      ],
    ),

    // Branch untuk Tab Financial / Stream
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/financial',
          builder: (context, state) => approvalsScreen,
        ),
      ],
    ),

    // Branch untuk Tab Management
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/management',
          builder: (context, state) => analyticsScreen,
        ),
      ],
    ),

    // Branch untuk Tab Sellers
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/sellers',
          builder: (context, state) => attendanceScreen,
        ),
      ],
    ),

    // Branch untuk Tab Attendance
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/attendance',
          builder: (context, state) => attendanceScreen,
        ),
      ],
    ),
  ];
}