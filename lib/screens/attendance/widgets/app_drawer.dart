// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:matrix_sphere/navigations/app_routes.dart';
import 'package:matrix_sphere/navigations/app_extractor.dart';
import 'package:shared_ui/shared_ui.dart';

final Logger logger = Logger();

void _closeDrawerSafely(BuildContext context) {
  final ScaffoldState? scaffold = Scaffold.maybeOf(context);
  if (scaffold != null && scaffold.isDrawerOpen) {
    scaffold.closeDrawer();
  }
}

void _openScreenAfterClosingDrawer(BuildContext context, Widget page) {
  _closeDrawerSafely(context);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  });
}

// Definisi struktur data untuk item menu dengan tambahan properti 'label'
class MenuDrawer {
  final String title;
  final IconData icon;
  final String label; // Keterangan fungsi menu
  final String route;
  final VoidCallback? onTap;

  MenuDrawer({
    required this.title,
    required this.icon,
    required this.label,
    required this.route,
    this.onTap,
  });
}

// Daftar rekomendasi item menu Drawer khusus saat berada di Halaman Attendance
List<MenuDrawer> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    MenuDrawer(
      title: 'Kalender Kehadiran',
      icon: Icons.calendar_month,
      label:
          'Kalender bulanan berwarna untuk melihat tanggal sudah absen dan tidak absen.',
      route: AppRoutes.attendanceHistory,
      onTap: () {
        logger.i('Navigasi ke Kalender Riwayat Absensi');
        _openScreenAfterClosingDrawer(
          context,
          const AttendanceHistoryScreen(),
        );
      },
    ),
    MenuDrawer(
      title: 'Riwayat Kehadiran',
      icon: Icons.history,
      label: 'Melihat catatan riwayat jam masuk, jam pulang, dan status harian.',
      route: AppRoutes.attendanceHistory,
      onTap: () {
        logger.i('Navigasi ke Riwayat Kehadiran');
        _openScreenAfterClosingDrawer(
          context,
          const AttendanceHistoryScreen(),
        );
      },
    ),
    MenuDrawer(
      title: 'Profil & Jam Kerja Kantor',
      icon: Icons.apartment_outlined,
      label:
          'Memeriksa jam operasional Matrix Sphere, alamat, dan titik koordinat kantor.',
      route: '/company-profile',
      onTap: () {
        logger.i('Navigasi ke Profil Perusahaan');
        _openScreenAfterClosingDrawer(
          context,
          const CompanyProfile(),
        );
      },
    ),
    MenuDrawer(
      title: 'Pengaturan Lokasi & Jam Kerja',
      icon: Icons.edit_location_alt_outlined,
      label:
          'Mengatur jam masuk/pulang, titik koordinat kantor (PIN Lock), dan radius.',
      route: '/edit-company',
      onTap: () {
        logger.i('Navigasi ke Edit Profil Perusahaan');
        _openScreenAfterClosingDrawer(
          context,
          const EditCompanyPage(),
        );
      },
    ),
    MenuDrawer(
      title: 'Work Calendar / Kalender Kerja',
      icon: Icons.calendar_today,
      label: 'Memeriksa jadwal shift kerja, hari libur, dan jadwal cuti.',
      route: '',
      onTap: () {
        logger.i('Menu Work Calendar diklik');
        _closeDrawerSafely(context);
      },
    ),
    MenuDrawer(
      title: 'Tasks / Tugas Harian',
      icon: Icons.task,
      label:
          'Melihat daftar tugas atau target kerja harian yang harus diselesaikan.',
      route: '',
      onTap: () {
        logger.i('Menu Tasks diklik');
        _closeDrawerSafely(context);
      },
    ),
    MenuDrawer(
      title: 'Profile / Profil',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun staf atau karyawan.',
      route: AppRoutes.userProfile,
      onTap: () {
        logger.i('Navigasi ke User Profile');
        _closeDrawerSafely(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          AppNavigation.openUserProfile(context);
        });
      },
    ),
  ];
}

List<SideMenuItem> getDrawerSideMenuItems(
  BuildContext context,
  String currentRoute,
) {
  final List<MenuDrawer> drawerItems = getDrawerItems(context, currentRoute);

  return drawerItems.map((MenuDrawer item) {
    return SideMenuItem(
      title: item.title,
      icon: item.icon,
      label: item.label,
      route: item.route,
      isSelected: item.route.isNotEmpty && item.route == currentRoute,
      onTap: item.onTap ?? () {},
    );
  }).toList();
}