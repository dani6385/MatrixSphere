// lib/navigation/app_shell_branches.dart

//import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'custom_transition_page.dart';
//import 'app_common_routes.dart';
import 'app_extractor.dart';

// Kunci navigator untuk setiap cabang/tab.
// Ini penting agar navigasi ke halaman detail (seperti add/edit product)
// tetap berada di dalam tab yang sama dan tidak menutupi bottom nav bar.
final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'ShellHome');
final _shellNavigatorSellersKey =
    GlobalKey<NavigatorState>(debugLabel: 'ShellSellers');

/// Daftar cabang untuk [StatefulShellRoute].
/// Setiap [StatefulShellBranch] mewakili satu tab pada bottom navigation bar.
final List<StatefulShellBranch> appShellBranches = [
  // Branch untuk Tab Home
  StatefulShellBranch(
    navigatorKey: _shellNavigatorHomeKey,
    routes: [GoRoute(path: '/', builder: (context, state) => const Center())],
  ),

  // Branch untuk Tab Stream
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.financial,
        pageBuilder: (context, state) =>
            FadeTransitionPage(child: const Center()),
        routes: const [],
      ),
    ],
  ),

  // Branch untuk Tab Management
  StatefulShellBranch(routes: [
    GoRoute(
      path: AppRoutes.management,
      pageBuilder: (context, state) =>
          FadeTransitionPage(child: const Center()),
    )
  ]),

  // Branch untuk Tab Sellers (Products)
  StatefulShellBranch(
    navigatorKey: _shellNavigatorSellersKey,
    routes: [
      GoRoute(
        path: AppRoutes.sellers,
        // name: AppRoutes.publicProduct, // Name is often better on the top-level route for clarity
        builder: (context, state) => const ProductScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.product,
            // name: AppRoutes.publicProduct, // Name is often better on the top-level route for clarity
            builder: (context, state) => const ProductScreen(),
            routes: [
              GoRoute(
                path: '/products/add',
                // name: AppRoutes.addProduct,
                builder: (context, state) => const ProductFormScreen(),
              ),
              GoRoute(
                  path: '/products/edit/:productId',
                  // name: AppRoutes.editProduct,
                  builder: (context, state) => ProductFormScreen(
                      productId: state.pathParameters['productId'])),
            ],
          ),
        ],
      ),
    ],
  ),

  // Branch untuk Tab Attendance
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.attendance,
        pageBuilder: (context, state) => FadeTransitionPage(
            child: const Center()), // Placeholder, ganti dengan screen Anda
        routes: const [],
      ),
    ],
  ),
];
