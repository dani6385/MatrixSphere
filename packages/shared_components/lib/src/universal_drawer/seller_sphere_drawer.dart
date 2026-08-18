import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

class SellerSphereDrawer {
  static final Logger _logger = Logger();

  static List<SideMenuItem> getDrawerItems(BuildContext context, PageType pageType, String currentRoute) {
    if (pageType == PageType.home) {
      return [
        SideMenuItem(
          title: 'Home / Beranda',
          icon: Icons.home,
          label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Simulasi',
          icon: Icons.dashboard,
          label: 'Menampilkan ringkasan statistik penjualan dan performa toko.',
          onTap: () => _logger.i('Simulasi tapped'),
          route: '',
        ),
        // ... (masukkan item seller sphere lainnya di sini)
      ];
    }
    return [];
  }

  static List<SideMenuItem> getEndDrawerItems(BuildContext context, PageType pageType) {
    return [
      SideMenuItem(
        title: 'Profile',
        icon: Icons.person,
        label: 'Melihat dan mengubah informasi profil akun toko.',
        route: '/user-profile',
        onTap: () => context.go('/user-profile'),
      ),
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Mengatur preferensi dasar aplikasi secara keseluruhan.',
        route: '/setting',
        onTap: () => context.go('/setting'),
      ),
    ];
  }
}