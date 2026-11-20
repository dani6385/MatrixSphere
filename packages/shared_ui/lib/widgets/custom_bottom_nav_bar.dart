import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

/// Shared bottom navigation bar dengan bentuk melengkung (`CurvedNavigationBar`)
/// dan dukungan pemisahan warna ikon saat terpilih (`selectedIconColor`)
/// maupun tidak terpilih (`unselectedIconColor`).
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
  });

  /// Indeks tab aktif saat ini.
  final int currentIndex;

  /// Callback saat tab ditekan.
  final void Function(int) onTap;

  /// Indeks item yang sedang terpilih pada bar.
  final int selectedIndex;

  /// Daftar item tab sumber ikon.
  final List<GButton> tabs;

  /// Warna ikon ketika item sedang dipilih (selected).
  final Color? selectedIconColor;

  /// Warna ikon ketika item tidak dipilih (unselected).
  final Color? unselectedIconColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Warna default jika parameter tidak dikirim dari BottomNavBar
    final Color activeColor = selectedIconColor ?? kBrandPrimary;
    final Color inactiveColor = unselectedIconColor ?? colorScheme.onSurfaceVariant;

    // Membuat daftar Icon berdasarkan posisi indeks terhadap selectedIndex
    final List<Widget> items = List<Widget>.generate(tabs.length, (int index) {
      final bool isSelected = index == selectedIndex;
      final IconData iconData = tabs[index].icon;

      return Icon(
        iconData,
        size: 22,
        color: isSelected ? activeColor : inactiveColor,
      );
    });

    return ClipPath(
      clipper: _BottomNavClipper(),
      child: Container(
        height: 75.0,
        decoration: const BoxDecoration(
          color: kTransparent,
        ),
        child: CurvedNavigationBar(
          index: selectedIndex,
          height: 50,
          items: items,
          onTap: onTap,
          color: kNeonCyan,
          buttonBackgroundColor: kDarkDivider,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeIn,
          animationDuration: const Duration(milliseconds: 400),
        ),
      ),
    );
  }
}

/// CustomClipper untuk membentuk lengkungan bawah pada navigation bar.
class _BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double curveDepth = 20.0;

    path.moveTo(0, curveDepth);
    path.quadraticBezierTo(size.width / 2, 0, size.width, curveDepth);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}