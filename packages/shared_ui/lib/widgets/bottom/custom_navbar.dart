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

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
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

    return CurvedNavigationBar(
      index: currentIndex,
      height: 60.0,
      items: navIcons,
      color: kBrandPrimary, // Menggunakan warna utama dari shared_ui
      buttonBackgroundColor: kBrandPrimary, // Warna latar tombol yang aktif
      backgroundColor: Colors.transparent, // Warna latar di luar bilah navigasi
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: onTap,
    );
  }
}