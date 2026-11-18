import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_components/shared_components.dart';
import 'widgets/app_drawer_items.dart';
import 'widgets/app_end_drawer_items.dart';
import 'bottom_nav_bar.dart';

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigator({
    super.key,
    required this.navigationShell,
  });

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  void Function(int) get _onItemTapped =>
      (index) => widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );

  @override
  Widget build(BuildContext context) {
    // Mengambil indeks halaman aktif dari navigationShell
    final int currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      extendBody: true,
      body: widget.navigationShell,
      drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getDrawerSideMenuItems(context, currentRoute);
        },
      ),
      endDrawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getEndDrawerSideMenuItems(context, currentRoute);
        },
      ),
      bottomNavigationBar: BottomNavBar(
        navigationShell: widget.navigationShell,
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
