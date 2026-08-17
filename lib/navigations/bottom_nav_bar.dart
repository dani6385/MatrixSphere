import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:logger/logger.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';

import 'package:shared_navigations/shared_navigation.dart';

final Logger logger = Logger();

/// A wrapper widget that configures and displays the [SharedBottomNavBar]
/// with tabs specific to the Seller Sphere application.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    // Data untuk ikon, dipetakan berdasarkan rute
    const Map<String, ({IconData icon, IconData activeIcon})> tabIcons = {
      AppRoutes.home: (icon: Icons.home_outlined, activeIcon: Icons.home),
      AppRoutes.financial: (icon: Icons.analytics, activeIcon: Icons.analytics),
      AppRoutes.management: (
        icon: Icons.point_of_sale,
        activeIcon: Icons.point_of_sale_outlined
      ),
      AppRoutes.sellers: (
        icon: Icons.person,
        activeIcon: Icons.person_2_outlined
      ),
      AppRoutes.attendance: (
        icon: Icons.fingerprint_outlined,
        activeIcon: Icons.fingerprint
      ),
    };

    return SharedBottomNavBar(
      currentIndex: currentIndex,
      onTap: (index) {
        final List<String> routes = tabIcons.keys.toList();
        if (index < routes.length) {
          AppNavigation.goToTab(context, routes[index]);
        }
      },
      tabs: tabIcons.entries.map((entry) {
        final String route = entry.key;
        final ({IconData icon, IconData activeIcon}) icons = entry.value;
        String label = ''; // Default label

        // Set label based on route
        if (route == AppRoutes.home) {
          label = 'Home';
        } else if (route == AppRoutes.financial) {
          label = 'Financial';
        } else if (route == AppRoutes.management) {
          label = 'Management';
        } else if (route == AppRoutes.sellers) {
          label = 'Sellers';
        } else if (route == AppRoutes.attendance) {
          label = 'Attendance';
        }

        return GButton(
          icon: icons.icon,
          text: label,
        );
      }).toList(),
      selectedIndex: currentIndex,
      items: [],
    );
  }
}
