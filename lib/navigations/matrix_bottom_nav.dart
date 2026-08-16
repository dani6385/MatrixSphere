import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:logger/logger.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'matrix_branches.dart';

final Logger logger = Logger();

class MatrixBottomNavBar extends StatelessWidget {
  const MatrixBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.navigationShell, // Terima navigationShell
  });

  final int currentIndex;
  final void Function(int) onTap;
  final StatefulNavigationShell navigationShell; // Simpan navigationShell

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

    // Bungkus dengan Scaffold
    return Scaffold(
      // Gunakan navigationShell sebagai body untuk menampilkan konten halaman
      body: navigationShell,
      // Tempatkan bilah navigasi di bagian bawah
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // ... (logika logging Anda tetap di sini)
          final routePath = (matrixBranches[index].routes.first as dynamic).path;
          if (routePath == AppRoutes.approvals) {
            logger.i(
                'Mengakses Halaman Reports / Laporan untuk memantau grafik penjualan pendapatan toko secara real-time.');
          } else if (routePath == AppRoutes.analytics) {
            logger.i(
                'Pusat kendali khusus bagi penjual untuk memantau performa penjualan produk.');
          } else if (routePath == AppRoutes.transactions) {
            logger.i(
                'Mengakses fitur pengelolaan operasional, staf, atau pengaturan toko secara mendetail.');
          } else if (routePath == AppRoutes.attendance) {
            logger.i(
                'Mengakses fitur pencatatan presensi, jam kerja, atau shift karyawan.');
          }
          onTap(index); // Panggil fungsi onTap asli untuk berpindah tab
        },
        tabs: List.generate(matrixBranches.length, (index) {
          final isSelected = index == currentIndex;
          final routePath = (matrixBranches[index].routes.first as dynamic).path;
          final icons = tabIcons[routePath]!;
          return GButton(
            icon: isSelected ? icons.activeIcon : icons.icon,
          );
        }),
        selectedIndex: currentIndex,
        items: const [],
      ),
    );
  }
}
