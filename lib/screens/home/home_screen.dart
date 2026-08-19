// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'components/home_appbar.dart';
import 'components/home_body.dart';
import 'package:shared_navigations/shared_navigations.dart';
import 'widgets/home_drawer_items.dart';
import 'widgets/home_end_drawer_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold itself will have a transparent background by default
      appBar: const HomeAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          // Panggil fungsi atau list item SideMenuItem yang ada di home_drawer_items.dart
          return getDrawerSideMenuItems(context, currentRoute);
        },
      ),
      endDrawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          // Panggil fungsi atau list item SideMenuItem yang ada di home_drawer_items.dart
          return getEndDrawerSideMenuItems(context, currentRoute);
        },
      ),
      body: const HomeBody(),
    );
  }
}
