// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu EndDrawer yang ditambah properti 'label'
class MenuDrawer {
  final String title;
  final IconData icon;
  final String label; // Properti untuk menyimpan keterangan fungsi
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

// Daftar rekomendasi item menu EndDrawer khusus saat di Halaman Home
List<MenuDrawer> getEndDrawerItems(BuildContext context, String currentRoute) {
  return [
    MenuDrawer(
      title: 'Dark Mode',
      icon: Icons.dark_mode,
      label: 'Mengubah tema tampilan aplikasi menjadi mode gelap atau terang.',
      route: '',
      onTap: () {
        if (Navigator.canPop(context)) {
          Scaffold.of(context).closeDrawer();
        }
      },
    ),
    MenuDrawer(
      title: 'Logout',
      icon: Icons.logout,
      label: 'Keluar dari sesi akun aktif pada aplikasi.',
      route: '',
      onTap: () async {
        try {
          // Tutup laci navigasi terlebih dahulu jika terbuka
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          // Keluar dari sesi Firebase Auth
          await FirebaseAuth.instance.signOut();
          logger.i('Berhasil logout dari akun.');

          // Pastikan widget/halaman masih aktif sebelum pindah halaman
          if (!context.mounted) return;

          // Arahkan langsung ke halaman login menggunakan GoRouter
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
      route: '', // Sesuaikan rute jika diperlukan
      isSelected: false,
      onTap:
          item.onTap ??
          () {}, // Provide an empty function if item.onTap is null
    );
  }).toList();
}
