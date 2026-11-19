import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// Aktifkan import ini jika kamu sudah menghubungkan paket `shared_navigations`
// melalui `melos bootstrap` dan ingin membungkus komponen dari paket tersebut:
// import 'package:shared_navigations/shared_navigations.dart';

/// Bilah navigasi bawah (Bottom Navigation Bar) untuk cangkang utama `AppNavigator`.
/// Urutan tab di `tabs` harus sama persis dengan urutan `StatefulShellBranch`
/// pada `app_branches.dart`:
/// 0: Home | 1: Approvals | 2: Analytics | 3: Transactions | 4: Attendance
class BottomNavBar extends StatelessWidget {
  /// Pengontrol shell navigasi GoRouter.
  final StatefulNavigationShell navigationShell;

  /// Indeks tab yang sedang aktif saat ini.
  final int currentIndex;

  /// Fungsi callback saat tab ditekan (`_onItemTapped` di `AppNavigator`).
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.navigationShell,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Daftar tab harus sejajar dengan 5 branch di `app_branches.dart`
    final List<GButton> tabs = <GButton>[
      const GButton(
        icon: Icons.home,
        text: 'Home',
      ),
      const GButton(
        icon: Icons.approval,
        text: 'Approvals',
      ),
      const GButton(
        icon: Icons.analytics,
        text: 'Analytics',
      ),
      const GButton(
        icon: Icons.receipt_long,
        text: 'Transactions',
      ),
      const GButton(
        icon: Icons.access_time,
        text: 'Attendance',
      ),
    ];

    // Menggunakan GNav dari `google_nav_bar` agar langsung berfungsi stabil
    // meskipun paket `shared_navigations` belum selesai di-link atau berbeda API.
    // Jika ingin memakai `CustomBottomNavBar` dari `shared_navigations`, pastikan
    // nama kelas dan parameternya sesuai dengan isi paket `shared_navigations`.
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: GNav(
            selectedIndex: currentIndex,
            onTabChange: onTap,
            gap: 6,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            tabBackgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
            activeColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}