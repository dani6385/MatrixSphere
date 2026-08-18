import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_components/src/universal_drawer/universal_drawer.dart';
import 'package:shared_components/src/universal_drawer/universal_drawer_header.dart';
import 'package:shared_components/src/universal_drawer/universal_drawer_items.dart';
import 'package:shared_ui/shared_ui.dart';

/// A factory class for creating drawers and end drawers for different features.
/// This promotes code reuse and centralizes drawer creation logic.
class DrawerFactory {
  /// Creates a main drawer (left side) based on the specified [feature].
  static Widget? createDrawer(BuildContext context,
      {required AppType appType, required PageType pageType}) {
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final items = getUniversalDrawerItems(context,
        appType: appType, pageType: pageType, currentRoute: currentRoute);

    if (items.isEmpty) return null;

    // Logika untuk memilih header berdasarkan fitur
    Widget header;
    if (appType == AppType.matrixSphere && pageType == PageType.home) {
      header = const UniversalDrawerHeader(title: 'Menu', icon: Icons.person_outline, backgroundColor: Colors.blue);
    } else if (appType == AppType.sellerSphere) {
      // Header spesifik untuk Seller Sphere App
      header = const UniversalDrawerHeader(title: 'Seller Menu', icon: Icons.store, backgroundColor: Colors.deepOrange);
    } else if (appType == AppType.shopSphere) {
      // Header untuk Shop Sphere (bisa digunakan untuk attendance di app lain)
      header = const UniversalDrawerHeader(title: 'Menu', icon: Icons.fingerprint, backgroundColor: Colors.blue);
    } else if (appType == AppType.matrixSphere && pageType == PageType.attendance) {
      // Header spesifik untuk halaman Attendance di app MatrixSphere
      header = const UniversalDrawerHeader(title: 'Menu', icon: Icons.fingerprint, backgroundColor: Colors.blue);
    } else {
      header = const UniversalDrawerHeader(title: 'Menu', icon: Icons.menu, backgroundColor: Colors.grey);
    }

    return UniversalDrawer(header: header, items: items, selectedRoute: currentRoute);
  }

  /// Creates an end drawer (right side) based on the specified [feature].
  static Widget? createEndDrawer(BuildContext context,
      {required AppType appType, required PageType pageType}) {
    final items =
        getUniversalEndDrawerItems(context, appType: appType, pageType: pageType);

    // Logika untuk memilih header EndDrawer
    IconData icon;
    if (appType == AppType.sellerSphere || (appType == AppType.matrixSphere && pageType == PageType.home)) {
      icon = Icons.settings;
    } else {
      icon = Icons.calendar_today; // Default atau untuk attendance
    }

    return UniversalDrawer(
      header: UniversalDrawerHeader(title: 'Pengaturan', icon: icon, backgroundColor: Colors.blue),
      items: items,
    );
  }
}