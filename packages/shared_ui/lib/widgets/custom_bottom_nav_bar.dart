import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

/// Widget navigasi bawah kustom dengan lengkungan ke atas dan pemisahan
/// warna ikon antara item yang terpilih dan tidak terpilih.
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
    required this.selectedIndex,
    required List<dynamic> items,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.curveHeight = 18.0,
  });

  /// Indeks tab aktif saat ini.
  final int currentIndex;

  /// Callback saat tab ditekan.
  final void Function(int) onTap;

  /// Indeks item yang sedang terpilih.
  final int selectedIndex;

  /// Daftar tab sumber ikon.
  final List<GButton> tabs;

  /// Warna ikon saat item terpilih (selected).
  final Color? selectedIconColor;

  /// Warna ikon saat item tidak terpilih (unselected).
  final Color? unselectedIconColor;

  /// Tinggi lengkungan ke atas pada bagian atas bar.
  final double curveHeight;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Warna ikon terpilih (default ke kBrandPrimary agar selaras dengan tema)
    final Color activeIconColor = selectedIconColor ?? kBrandPrimary;

    // Warna ikon tidak terpilih
    final Color inactiveIconColor =
        unselectedIconColor ?? colorScheme.onSurfaceVariant;

    // Membangun daftar widget Icon dengan warna berbeda untuk item terpilih
    final List<Widget> items = List<Widget>.generate(tabs.length, (int index) {
      final bool isSelected = index == selectedIndex;
      return Icon(
        tabs[index].icon,
        size: 22,
        color: isSelected ? activeIconColor : inactiveIconColor,
      );
    });

    return ClipPath(
      clipper: _UpwardCurveClipper(curveHeight: curveHeight),
      child: Container(
        height: 75.0,
        decoration: const BoxDecoration(
          color: kTransparent,
        ),
        child: CurvedNavigationBar(
          index: selectedIndex,
          height: 52,
          items: items,
          onTap: onTap,
          color: kNeonCyan,
          buttonBackgroundColor: kDarkDivider,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 350),
        ),
      ),
    );
  }
}

/// Clipper untuk membentuk sisi atas yang melengkung ke atas (cembung ke atas).
class _UpwardCurveClipper extends CustomClipper<Path> {
  final double curveHeight;

  const _UpwardCurveClipper({required this.curveHeight});

  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Mulai dari kiri bawah area lengkungan atas
    path.moveTo(0, curveHeight);

    // Tarik kurva melengkung ke atas menuju titik tengah (y = 0) lalu turun ke kanan
    path.quadraticBezierTo(
      size.width / 2,
      0,
      size.width,
      curveHeight,
    );

    // Tutup jalur hingga pojok kanan bawah dan kiri bawah
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_UpwardCurveClipper oldClipper) {
    return oldClipper.curveHeight != curveHeight;
  }
}