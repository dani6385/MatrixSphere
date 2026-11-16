// lib/screens/Analytic_screen.dart

import 'package:flutter/material.dart';
import 'package:matrix_sphere/screens/analytics/widgets/analytic_body.dart';
import 'package:matrix_sphere/screens/analytics/widgets/drawer_items.dart';
import 'package:matrix_sphere/screens/analytics/widgets/end_drawer_items.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:matrix_sphere/screens/analytics/widgets/analytic_appbar.dart';

class AnalyticScreen extends StatelessWidget {
  const AnalyticScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AnalyticAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getDrawerSideMenuItems(context, currentRoute);
        },
        header: const UserAccountsDrawerHeader(
          accountName: Text('Matrix Sphere'),
          accountEmail: Text('admin@matrixsphere.id'),
          currentAccountPicture: CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
      ),
      endDrawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getEndDrawerSideMenuItems(context, currentRoute);
        },
        header: const UserAccountsDrawerHeader(
          accountName: Text('Matrix Sphere'),
          accountEmail: Text('admin@matrixsphere.id'),
          currentAccountPicture: CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
      ),
      // Menggunakan ListView sebagai body standar agar halaman bisa digulir
      body: const AnalyticBody(),
    );
  }
}