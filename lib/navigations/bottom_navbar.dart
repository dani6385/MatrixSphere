import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

/// Custom Bottom Navigation Bar for the main application shell.
///
/// Menyediakan item navigasi utama dengan pemisahan warna yang jelas
/// antara tab yang sedang aktif (selected) dan tidak aktif (unselected).
class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.navigationShell,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Mengambil skema warna tema aktif (terang / gelap) sebagai cadangan aman
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // 1. Konfigurasi warna tab yang TIDAK TERPILIH (unselected)
    final Color unselectedColor = colorScheme.onSurfaceVariant;

    // 2. Konfigurasi warna tab yang TERPILIH (selected)
    // Menggunakan kBrandPrimary dari shared_ui agar selaras dengan tema aplikasi
    final Color selectedColor = kBrandPrimary;

    // 3. Warna latar belakang khusus untuk tab yang sedang aktif (selected)
    final Color selectedBackgroundColor = kBrandPrimary.withValues(alpha: 0.14);

    // Daftar tab harus sesuai urutan StatefulShellBranch pada app_branches.dart
    final List<GButton> tabs = [
      GButton(
        icon: Icons.home,
        text: 'Home',
        iconColor: unselectedColor,
        iconActiveColor: selectedColor,
        backgroundColor: selectedBackgroundColor,
      ),
      GButton(
        icon: Icons.approval,
        text: 'Approvals',
        iconColor: unselectedColor,
        iconActiveColor: selectedColor,
        backgroundColor: selectedBackgroundColor,
      ),
      GButton(
        icon: Icons.analytics,
        text: 'Analytics',
        iconColor: unselectedColor,
        iconActiveColor: selectedColor,
        backgroundColor: selectedBackgroundColor,
      ),
      GButton(
        icon: Icons.receipt_long,
        text: 'Transactions',
        iconColor: unselectedColor,
        iconActiveColor: selectedColor,
        backgroundColor: selectedBackgroundColor,
      ),
      GButton(
        icon: Icons.access_time,
        text: 'Attendance',
        iconColor: unselectedColor,
        iconActiveColor: selectedColor,
        backgroundColor: selectedBackgroundColor,
      ),
    ];

    return CustomBottomNavBar(
      currentIndex: currentIndex,
      selectedIndex: currentIndex,
      onTap: onTap,
      tabs: tabs,
      items: const [],
    );
  }
}