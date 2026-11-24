// lib/navigation/widgets/app_drawer_items.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
//import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

final Logger logger = Logger();

class MenuDrawer {
  final String title;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  MenuDrawer({
    required this.title,
    required this.icon,
    required this.label,
    this.onTap,
  });
}

List<MenuDrawer> getDrawerItems(BuildContext context, String currentRoute) {
  final String? currentUid = FirebaseAuth.instance.currentUser?.uid;

  return [
    if (currentUid == 'mjS1Y9Ll3JRQCMGSTK2oIBVIHT22')
      MenuDrawer(
        title: 'Kelola Jabatan Pekerja',
        icon: Icons.admin_panel_settings,
        label: 'Mengatur jabatan dan status kerja setiap akun karyawan.',
        onTap: () {
          logger.i('Kelola Jabatan Pekerja tapped');
        },
      ),
    MenuDrawer(
      title: 'Status Toko',
      icon: Icons.info_outline,
      label:
          'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
      onTap: () {
        logger.i('Status Toko tapped');
      },
    ),
  ];
}

List<SideMenuItem> getDrawerSideMenuItems(
  BuildContext context,
  String currentRoute,
) {
  final drawerItems = getDrawerItems(context, currentRoute);

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
