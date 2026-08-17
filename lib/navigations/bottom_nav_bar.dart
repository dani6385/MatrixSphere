import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:go_router/src/route.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:logger/logger.dart';

//import 'package:shared_ui/shared_ui.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'app_branches.dart';

final Logger logger = Logger();

/// A wrapper widget that configures and displays the [SharedBottomNavBar]
/// with tabs specific to the Shop Sphere application.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required StatefulNavigationShell navigationShell,
  });

  final int currentIndex;
  final void Function(int) onTap;

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

    return SharedBottomNavBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // Ambil rute berdasarkan indeks cabang yang ditekan
        final routePath = (appBranches[index].routes.first as dynamic).path;
        if (routePath == AppRoutes.approvals) {
          logger.i(
              'Mengakses Halaman Reports / Laporan untuk memantau grafik penjualan pendapatan toko secara real-time.'); // Log aktivitas
        }
        // Periksa apakah rute yang diklik adalah halaman Reports
        if (routePath == AppRoutes.analytics) {
          logger.i(
              'Pusat kendali khusus bagi penjual untuk memantau performa penjualan produk.'); // Log aktivitas
        }
        if (routePath == AppRoutes.transactions) {
          logger.i(
              'Mengakses fitur pengelolaan operasional, staf, atau pengaturan toko secara mendetail.'); // Log aktivitas
        }
        if (routePath == AppRoutes.attendance) {
          logger.i(
              'Mengakses fitur pencatatan presensi, jam kerja, atau shift karyawan.'); // Log aktivitas
        }
        // Jalankan fungsi onTap bawaan
        onTap(index);
      },
      tabs: List.generate(appBranches
      .length, (index) {
        final isSelected = index == currentIndex;
        final routePath = (appBranches
        [index].routes.first as dynamic).path;
        final icons = tabIcons[routePath]!;
        return GButton(
          icon: isSelected ? icons.activeIcon : icons.icon,
        );
      }),
      selectedIndex: currentIndex,
      items: const [],
    );
  }
}
