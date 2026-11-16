// lib/screens/Project_screen.dart

import 'package:flutter/material.dart';
import 'package:matrix_sphere/screens/projects/widgets/project_drawer_items.dart';
import 'package:matrix_sphere/screens/projects/widgets/project_end_drawer_items.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:matrix_sphere/screens/projects/widgets/project_appbar.dart';
import 'package:matrix_sphere/screens/projects/widgets/project_body.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProjectAppBar(),
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
      body: const ProjectBody(),
    );
  }
}