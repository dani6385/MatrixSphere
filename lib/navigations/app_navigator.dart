import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/src/gbutton.dart';
import 'package:shared_navigations/shared_navigations.dart';

import 'package:shared_ui/shared_ui.dart';
import 'widgets/app_drawer_items.dart';
import 'widgets/app_end_drawer_items.dart';

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final AppType appType; // Tambahkan parameter ini

  const AppNavigator({
    super.key, 
    required this.navigationShell, 
    required this.appType // Wajib diisi
  });

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  
  void _onItemTapped(int index) {
    // GoRouter berpindah branch berdasarkan index navbar
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        tabs: getBottomNavBarItems(widget.appType),
        onTap: _onItemTapped,
        // navigationShell tidak perlu dikirim jika sudah ada currentIndex dan onTap
      ),
    );
  }

  List<GButton> getBottomNavBarItems(AppType appType) {
    // Daftar tab dasar yang ada di semua aplikasi
    List<GButton> items = [
      GButton(icon: Icons.home, text: 'Home'),
      GButton(icon: Icons.search, text: 'Search'),
    ];

    // Tambahkan tab spesifik berdasarkan AppType
    if (appType == AppType.matrixSphere) {
      items.addAll([
        GButton(icon: Icons.backup, text: 'Backup'),
        GButton(icon: Icons.bug_report, text: 'Debug'),
      ]);
    } else if (appType == AppType.shopSphere) {
      items.addAll([
        GButton(icon: Icons.history, text: 'Orders'),
        GButton(icon: Icons.location_on, text: 'Addresses'),
        GButton(icon: Icons.card_giftcard, text: 'Coupons'),
      ]);
    } else if (appType == AppType.sellerSphere) {
      items.addAll([
        GButton(icon: Icons.data_usage, text: 'Data'),
        GButton(icon: Icons.subscriptions, text: 'Subscription'),
      ]);
    }

    return items;
  }
}