import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

class MatrixSphereDrawer {
  static List<SideMenuItem> getDrawerItems(BuildContext context, PageType pageType, String currentRoute) {
    if (pageType == PageType.home) {
      return [
        SideMenuItem(
          title: 'Home / Beranda',
          icon: Icons.home,
          label: 'Kembali ke halaman utama dashboard.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
          
        ),
      ];
    }
    // Tambahkan kondisi halaman Matrix Sphere lainnya di sini...
    return [];
  }

  static List<SideMenuItem> getEndDrawerItems(BuildContext context, PageType pageType) {
    if (pageType == PageType.home) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
      ];
    }
    return [];
  }
}