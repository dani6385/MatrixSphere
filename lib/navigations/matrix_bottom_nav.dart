import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class MatrixBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MatrixBottomNav({
    super.key,
    required this.navigationShell,
    required int currentIndex,
    required void Function(int) onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomNavBar(
      currentIndex: navigationShell.currentIndex,
      onTap: (index) {
        // Perintah untuk memindahkan tab ke halaman yang ditekan
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      items: const [
        BottomNavBar(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
        ),
        BottomNavBar(
          icon: Icons.how_to_reg_outlined,
          activeIcon: Icons.how_to_reg,
          label: 'Approval',
        ),
        BottomNavBar(
          icon: Icons.analytics_outlined,
          activeIcon: Icons.analytics,
          label: 'Analytic',
        ),
        BottomNavBar(
          icon: Icons.work_outline,
          activeIcon: Icons.work,
          label: 'Project',
        ),
        BottomNavBar(
          icon: Icons.access_time_outlined,
          activeIcon: Icons.access_time,
          label: 'Attendance',
        ),
      ],
      tabs: null,
      selectedIndex: null,
    );
  }
}
