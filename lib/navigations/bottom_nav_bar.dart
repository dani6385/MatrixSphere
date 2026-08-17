import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:logger/logger.dart';

// Impor dari shared_ui jika diperlukan nanti
// import 'package:shared_ui/shared_ui.dart';

// Mengimpor shared_navigation dan menyembunyikan simbol yang berkonflik
import 'package:shared_navigations/shared_navigation.dart' hide appShellBranches;
import 'app_branches.dart';

final Logger logger = Logger();

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.navigationShell, // Menerima StatefulNavigationShell
  });

  // Menyimpan navigationShell sebagai properti dari widget
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // Data untuk ikon, dipetakan berdasarkan rute
    const Map<String, ({IconData icon, IconData activeIcon})> tabIcons = {
      AppRoutes.home: (icon: Icons.home_outlined, activeIcon: Icons.home),
      AppRoutes.approvals: (
        icon: Icons.store_mall_directory_outlined,
        activeIcon: Icons.store_mall_directory
      ),
      AppRoutes.analytics: (
        icon: Icons.analytics_outlined,
        activeIcon: Icons.analytics
      ),
      AppRoutes.transactions: (
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long
      ),
      AppRoutes.attendance: (
        icon: Icons.fingerprint_outlined,
        activeIcon: Icons.fingerprint
      ),
    };

    // Menggunakan Scaffold untuk memberikan struktur halaman yang benar
    return Scaffold(
      // Menampilkan konten halaman aktif (misalnya, HomeScreen)
      body: navigationShell,
      
      // Menempatkan bilah navigasi di bagian bawah
      bottomNavigationBar: BottomAppBar(
        child: GNav(
          selectedIndex: navigationShell.currentIndex,
          onTabChange: (index) {
            // Logika logging Anda
            final routePath = (appBranches[index].routes.first as GoRoute).path;
            if (routePath == AppRoutes.approvals) {
              logger.i('Mengakses Halaman Reports / Laporan...');
            } else if (routePath == AppRoutes.analytics) {
              logger.i('Pusat kendali khusus bagi penjual...');
            }
            // ... dan seterusnya untuk log lainnya

            // Memberitahu GoRouter untuk berpindah ke tab/branch yang dipilih
            navigationShell.goBranch(index);
          },
          tabs: List.generate(appBranches.length, (index) {
            final isSelected = index == navigationShell.currentIndex;
            final routePath = (appBranches[index].routes.first as GoRoute).path;
            final icons = tabIcons[routePath]!;
            return GButton(
              icon: isSelected ? icons.activeIcon : icons.icon,
            );
          }),
        ),
      ),
    );
  }
}
