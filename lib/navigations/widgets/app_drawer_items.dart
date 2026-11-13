// lib/navigations/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

// Definisi struktur data untuk item menu EndDrawer
class MenuDrawer {
  final String title;
  final IconData icon;
  final String label;
  final String route; // Tambahkan route agar bisa navigasi
  final VoidCallback? onTap;

  MenuDrawer({
    required this.title,
    required this.icon,
    required this.label,
    this.route = '',
    this.onTap,
  });
}

// Fungsi untuk mendapatkan daftar menu mentah berdasarkan AppType
List<MenuDrawer> getDrawerMenuItems(BuildContext context, String currentRoute) {
  // 1. Menu Dasar yang ada di semua aplikasi
  List<MenuDrawer> items = [
    MenuDrawer(title: 'Preferences', icon: Icons.tune, label: ''),
    MenuDrawer(title: 'Themes', icon: Icons.color_lens, label: ''),
    MenuDrawer(title: 'Backup & Restore', icon: Icons.backup, label: ''),
    MenuDrawer(title: 'Debug Info', icon: Icons.bug_report, label: ''),
    MenuDrawer(title: 'Order History', icon: Icons.history, label: ''),
    MenuDrawer(title: 'Addresses', icon: Icons.location_on, label: ''),
    MenuDrawer(title: 'Coupons', icon: Icons.card_giftcard, label: ''),
    MenuDrawer(title: 'Data Management', icon: Icons.data_usage, label: ''),
    MenuDrawer(
        title: 'Subscription Details', icon: Icons.subscriptions, label: ''),
  
    MenuDrawer(title: 'Privacy Policy', icon: Icons.privacy_tip, label: ''),
    MenuDrawer(title: 'Version', icon: Icons.info, label: '1.0.0'),
  ];

  return items;
}

// Fungsi utama yang dipanggil oleh AppNavigator
List<SideMenuItem> getDrawerSideMenuItems(
    BuildContext context, String currentRoute) {
  // Ambil data menu berdasarkan AppType
  final drawerItems = getDrawerMenuItems(context, currentRoute);

  return drawerItems.map((item) {
    return SideMenuItem(
      title: item.title,
      icon: item.icon,
      label: item.label,
      route: item.route,
      // Logika agar menu terlihat "terpilih" jika routenya sama
      isSelected: currentRoute == item.route,
      onTap: item.onTap ??
          () {
            // Logika default jika onTap tidak diisi
            print("Membuka halaman ${item.title} untuk aplikasi");
          },
    );
  }).toList();
}
