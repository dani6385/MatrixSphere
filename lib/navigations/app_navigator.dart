import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigations.dart';

import 'package:shared_ui/shared_ui.dart';
import 'widgets/app_drawer_items.dart';
import 'widgets/app_end_drawer_items.dart';

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  

  const AppNavigator(
      {super.key,
      required this.navigationShell,
      
      });

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  void Function(int) get _onItemTapped =>
      (index) => widget.navigationShell.goBranch(index);

  @override
  Widget build(BuildContext context) {
    // Ambil secara global
    

    return Scaffold(
      drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getDrawerSideMenuItems(context, currentRoute);
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onTap: _onItemTapped,
        // Cukup panggil AppConfig.currentApp di sini
        tabs: getBottomNavBarItems(currentApp),
      ),
      body: widget.navigationShell,
    );
  }
}

Widget build(BuildContext context, dynamic widget) {
  final void Function(int) _onItemTapped =
      (index) => widget.navigationShell.goBranch(index);
  return Scaffold(
    extendBody: true,
    body: widget.navigationShell, // Ini adalah konten halaman yang aktif
    drawer: SharedProjectDrawer(
      menuBuilder: (context, currentRoute) {
        // Kirim appType ke drawer agar menu drawer bisa berubah sesuai aplikasi
        return getDrawerSideMenuItems(context, currentRoute, widget.appType);
      },
    ),
    endDrawer: SharedProjectDrawer(
      menuBuilder: (context, currentRoute) {
        return getEndDrawerSideMenuItems(context, currentRoute, widget.appType);
      },
    ),
    bottomNavigationBar: SharedBottomNavBar(
      selectedIndex: widget.navigationShell.currentIndex,
      onTap: _onItemTapped,
      tabs: getBottomNavBarItems(
          widget.appType), // Fungsi ini sekarang mengembalikan List<GButton>
    ),
  );
}
