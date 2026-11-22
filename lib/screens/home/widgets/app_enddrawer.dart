// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

final Logger logger = Logger();

class MenuDrawer {
  final String title;
  final IconData icon;
  final String label;
  final String route;
  final VoidCallback? onTap;

  MenuDrawer({
    required this.title,
    required this.icon,
    required this.label,
    required this.route,
    this.onTap,
  });
}

List<MenuDrawer> getEndDrawerItems(BuildContext context, String currentRoute) {
  return [
    MenuDrawer(
      title: 'Dark Mode',
      icon: Icons.dark_mode,
      label: 'Mengubah tema tampilan aplikasi menjadi mode gelap atau terang.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Logout',
      icon: Icons.logout,
      label: 'Keluar dari sesi akun aktif pada aplikasi.',
      route: '',
      onTap: () async {
        try {
          await FirebaseAuth.instance.signOut();
          logger.i('Berhasil logout dari akun.');

          if (!context.mounted) return;
          AppNavigation.goToLogin(context);
        } catch (e) {
          logger.e('Gagal melakukan logout: $e');
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal keluar akun: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    ),
  ];
}

List<SideMenuItem> getEndDrawerSideMenuItems(
  BuildContext context,
  String currentRoute,
) {
  final drawerItems = getEndDrawerItems(context, currentRoute);

  return drawerItems.map((item) {
    return SideMenuItem(
      title: item.title,
      icon: item.icon,
      label: item.label,
      route: '',
      isSelected: false,
      onTap: item.onTap ?? () {},
    );
  }).toList();
}
