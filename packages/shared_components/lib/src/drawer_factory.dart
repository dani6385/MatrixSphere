// packages/shared_components/lib/src/drawer_factory.dart
import 'package:flutter/material.dart';

import 'attendance/attendance_drawer.dart';
import 'attendance/attendance_end_drawer.dart';
import 'home/home_drawer.dart';
import 'home/home_end_drawer.dart';

enum DrawerSide { left, right }

class AppDrawerFactory {
  static Widget buildDrawer({
    required DrawerSide side,
    required String category, // 'attendance', 'home', dll
  }) {
    if (side == DrawerSide.right) {
      // Logic untuk EndDrawer
      if (category == 'home') return const HomeEndDrawer();
      if (category == 'attendance') return const AttendanceEndDrawer();
      return const SizedBox(); 
    } else {
      // Logic untuk Drawer (kiri)
      if (category == 'home') return const HomeDrawer();
      if (category == 'attendance') return const AttendanceDrawer();
      return const SizedBox();
    }
  }
}