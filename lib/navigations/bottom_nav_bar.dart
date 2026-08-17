import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Widget yang berfungsi sebagai shell UI utama aplikasi.
///
/// Ini membangun Scaffold dengan BottomNavigationBar dan menggunakan
/// [navigationShell] yang disediakan oleh GoRouter untuk menampilkan
/// konten halaman yang sesuai dengan tab yang aktif.
class BottomNavBar extends StatelessWidget {
  /// Widget yang disediakan oleh [StatefulShellRoute] untuk merender
  /// halaman dari branch yang sedang aktif.
  final Widget navigationShell;

  /// Indeks dari tab yang sedang aktif.
  final int currentIndex;

  /// Callback yang dipanggil ketika tab baru dipilih.
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.navigationShell,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // INI BAGIAN PENTING:
      // Tampilkan konten dari rute yang aktif di sini.
      body: navigationShell,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed, // Agar semua item terlihat
        selectedItemColor: kBrandPrimary,
        unselectedItemColor: kDarkTextSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Approvals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined), label: 'Analytics'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: 'Transactions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.co_present_outlined), label: 'Attendance'),
        ],
      ),
    );
  }
}
