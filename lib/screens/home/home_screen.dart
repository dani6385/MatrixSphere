import 'package:flutter/material.dart';
import 'widgets/home_drawer_items.dart';
import 'widgets/home_end_drawer_items.dart';
import 'package:shared_navigations/shared_navigations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
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
      body: const Center(
        child: Text('Apaka sekarang benar saya ingin tahu hasilnya'),
      ),
    );
  }
}
