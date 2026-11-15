import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const BottomNavBar({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavBar> items;

  final dynamic tabs;

  final dynamic selectedIndex;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.tabs, // Changed from 'items' to 'tabs'
    required this.selectedIndex,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final navIcons = items.map((item) {
      final bool isActive = items.indexOf(item) == currentIndex;
      return Icon(
        isActive ? item.activeIcon : item.icon,
        size: 30,
        color: isActive ? Colors.white : Colors.white70,
      );
    }).toList();
    return ClipPath(
      clipper: _BottomNavClipper(), // Custom clipper for the shape
      child: Container(
        height: 75.0, // Fixed height for the curved shape to be visible
        decoration: const BoxDecoration(
            // Menggunakan const karena warna transparan
            color: kTransparent // Membuat Container terluar transparan
            ),
        child: CurvedNavigationBar(
          index: currentIndex,
          height: 60.0,
          items: navIcons,
          color: kBrandTertiary, // Menggunakan warna utama dari shared_ui
          buttonBackgroundColor: kBrandPrimary, // Warna latar tombol yang aktif
          backgroundColor:
              Colors.transparent, // Warna latar di luar bilah navigasi
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: onTap,
        ),
      ),
    );
  }
}

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
