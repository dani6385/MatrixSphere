// lib/navigation/widgets/app_drawer_items.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Tambahkan go_router untuk navigasi
import 'package:logger/logger.dart';
import 'package:shared_ui/shared_ui.dart'; // Impor shared_ui agar kita bisa menggunakan SideMenuItem

final Logger logger = Logger();

// Definisi struktur data untuk item menu lokal
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

// Daftar seluruh item menu drawer lokal
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

          if (Navigator.canPop(context)) {
            Scaffold.of(context).closeEndDrawer();
          }
          Future.delayed(const Duration(milliseconds: 100), () {
            if (context.mounted) {
              //context.pushToManageUsers();
            }
          });
        },
      ),
    MenuDrawer(
      title: 'Status Toko',
      icon: Icons.info_outline,
      label:
          'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
      onTap: () {
        logger.i('Status Toko tapped');
        if (Navigator.canPop(context)) {
          Scaffold.of(context).closeEndDrawer();
        }
      },
    ),
  ];
}

/// Fungsi helper untuk mengubah MenuDrawer lokal menjadi SideMenuItem shared_ui
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
      route: '', // Sesuaikan rute jika diperlukan
      isSelected: false,
      onTap:
          item.onTap ??
          () {}, // Provide an empty function if item.onTap is null
    );
  }).toList();
}
