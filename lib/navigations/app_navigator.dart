import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'matrix_bottom_nav.dart';

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
      /*drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getDrawerSideMenuItems(context, currentRoute);
        },
      ),
      endDrawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getEndDrawerSideMenuItems(context, currentRoute);
        },
      ),*/
      bottomNavigationBar: MatrixBottomNav(
        navigationShell: widget.navigationShell,
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
