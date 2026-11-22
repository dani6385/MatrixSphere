// lib/navigations/drawer_navigation_helper.dart

import 'package:flutter/material.dart';

/// Utilitas untuk menutup `drawer` atau `endDrawer` dengan aman sebelum
/// mengeksekusi aksi navigasi pada frame berikutnya agar tidak terjadi
/// tumpukan animasi atau modal barrier/scrim saat berpindah antar drawer dan halaman.
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
    final bool wasStartOpen =
        closeStartDrawer && (scaffold?.isDrawerOpen ?? false);
    final bool wasEndOpen =
        closeEndDrawer && (scaffold?.isEndDrawerOpen ?? false);

    if (wasStartOpen) {
      scaffold!.closeDrawer();
    } else if (wasEndOpen) {
      scaffold!.closeEndDrawer();
    }

    // Jika drawer/endDrawer terbuka, pastikan rute popup/drawer di atasnya
    // ikut dibersihkan dengan aman sebelum berpindah halaman.
    if (wasStartOpen || wasEndOpen) {
      final NavigatorState navigator = Navigator.of(context);
      navigator.popUntil((route) => route is! PopupRoute || route.isFirst);
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