import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart'; // Menggunakan konstanta warna/gaya dari shared_ui

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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          backgroundColor: Colors.transparent,
          indicatorColor: kBrandPrimary.withValues(alpha: 0.15), // Menggunakan warna dari shared_ui[cite: 8]
          destinations: items.map((item) {
            return NavigationDestination(
              icon: Icon(item.icon, color: Colors.grey),
              selectedIcon: Icon(item.activeIcon, color: kBrandPrimary),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}