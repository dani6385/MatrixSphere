import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tipe fungsi builder untuk membangun tampilan cangkang (shell) navigasi,
/// seperti `AppNavigator(navigationShell: navigationShell)`.
typedef AppShellBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
  StatefulNavigationShell navigationShell,
);

/// Membangun `StatefulShellRoute.indexedStack` untuk membungkus cabang-cabang
/// menu utama aplikasi (`appBranches`) di dalam cangkang navigasi (`AppNavigator`).
///
/// Menggunakan `.indexedStack` agar state halaman (seperti posisi scroll atau
/// input sementara) di setiap tab tetap terjaga saat berpindah tab.
StatefulShellRoute shellRoute({
  required AppShellBuilder shellBuilder,
  required List<StatefulShellBranch> branches,
  GlobalKey<NavigatorState>? parentNavigatorKey,
  String? restorationScopeId,
}) {
  return StatefulShellRoute.indexedStack(
    parentNavigatorKey: parentNavigatorKey,
    restorationScopeId: restorationScopeId,
    branches: branches,
    builder: (
      BuildContext context,
      GoRouterState state,
      StatefulNavigationShell navigationShell,
    ) {
      return shellBuilder(context, state, navigationShell);
    },
  );
}