// lib/screens/Attendance_screen.dart

import 'package:flutter/material.dart';
import 'package:matrix_sphere/screens/attendance/widgets/attendance_drawer_items.dart';
import 'package:matrix_sphere/screens/attendance/widgets/attendance_end_drawer_items.dart';
import 'package:matrix_sphere/screens/attendance/widgets/attendance_appbar.dart';
import 'package:matrix_sphere/screens/attendance/widgets/attendance_body.dart';
import 'package:shared_ui/shared_ui.dart';


class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AttendanceAppBar(),
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
      body: const AttendanceBody(),
    );
  }
}