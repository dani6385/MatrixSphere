// lib/navigations/drawer_navigation_helper.dart

import 'package:flutter/material.dart';

/// Utilitas untuk menutup `drawer` atau `endDrawer` dengan aman sebelum
/// mengeksekusi aksi navigasi pada frame berikutnya agar tidak terjadi
/// tumpukan animasi/scrim saat berpindah antar drawer dan halaman.
class DrawerNavigationHelper {
  DrawerNavigationHelper._();

  /// Menutup `drawer` atau `endDrawer` yang sedang terbuka (jika ada),
  /// lalu menjalankan [onNavigate] setelah frame saat ini selesai dirender.
  static void runAfterClose(
    BuildContext context,
    VoidCallback onNavigate, {
    bool closeStartDrawer = true,
    bool closeEndDrawer = true,
  }) {
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);

    if (closeStartDrawer && scaffold?.isDrawerOpen == true) {
      scaffold!.closeDrawer();
    } else if (closeEndDrawer && scaffold?.isEndDrawerOpen == true) {
      scaffold!.closeEndDrawer();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      onNavigate();
    });
  }

  /// Helper khusus navigasi ke **Home** dari dalam `drawer` maupun `endDrawer`.
  static void navigateToHome(
    BuildContext context,
    VoidCallback onNavigateToHome,
  ) {
    runAfterClose(context, onNavigateToHome);
  }
}