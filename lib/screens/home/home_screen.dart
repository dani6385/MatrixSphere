// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:matrix_sphere/screens/home/widgets/home_drawer_items.dart';
import 'package:matrix_sphere/screens/home/widgets/home_end_drawer_items.dart';
import 'package:shared_components/shared_components.dart';
import 'widgets/home_appbar.dart';

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
      //body: const HomeBody(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang, Admin!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Halaman utama beranda aktif.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}