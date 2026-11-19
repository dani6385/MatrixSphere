import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_navbar.dart';

/// Widget cangkang (shell) navigasi utama aplikasi Matrix Sphere.
/// Membungkus `StatefulNavigationShell` dari GoRouter dengan `Scaffold`
/// dan `BottomNavBar` agar bilah navigasi tetap tampil di semua tab utama.
class AppNavigator extends StatefulWidget {
  /// Pengontrol status dan perpindahan cabang (branch) dari GoRouter.
  final StatefulNavigationShell navigationShell;

  const AppNavigator({
    super.key,
    required this.navigationShell,
  });

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  /// Fungsi yang dipanggil ketika salah satu item di BottomNavBar ditekan.
  /// - `index`: urutan tab yang dipilih (0 sampai jumlah branch - 1).
  /// - `initialLocation`: jika pengguna menekan tab yang sedang aktif,
  ///   halaman akan dikembalikan ke rute awal tab tersebut.
  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil indeks cabang (tab) yang sedang aktif saat ini
    final int currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      // Memungkinkan konten body memanjang hingga ke belakang bottomNavigationBar
      // (berguna jika BottomNavBar berbentuk melayang / transparan)
      extendBody: true,

      // Menampilkan halaman aktif sesuai cabang yang dipilih
      body: widget.navigationShell,

      // =======================================================================
      // OPSIONAL: Drawer samping (aktifkan jika SharedProjectDrawer sudah siap)
      // Catatan: pastikan parameter `header` diisi widget valid seperti
      // `const SizedBox.shrink()` (bukan `null`) agar tidak error tipe data.
      // =======================================================================
      /*
      drawer: SharedProjectDrawer(
        header: const SizedBox.shrink(),
        menuBuilder: (context, currentRoute) {
          return getDrawerSideMenuItems(context, currentRoute);
        },
      ),
      endDrawer: SharedProjectDrawer(
        header: const SizedBox.shrink(),
        menuBuilder: (context, currentRoute) {
          return getEndDrawerSideMenuItems(context, currentRoute);
        },
      ),
      */

      // Bilah navigasi bawah utama
      bottomNavigationBar: BottomNavBar(
        navigationShell: widget.navigationShell,
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}