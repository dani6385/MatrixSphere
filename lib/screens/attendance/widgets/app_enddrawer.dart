// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matrix_sphere/navigations/app_extractor.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

// Definisi struktur data untuk item menu EndDrawer dengan tambahan properti 'label'
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

void _closeEndDrawerSafely(BuildContext context) {
  final ScaffoldState? scaffold = Scaffold.maybeOf(context);
  if (scaffold != null && scaffold.isEndDrawerOpen) {
    scaffold.closeEndDrawer();
  }
}

void _navigateAfterClosingDrawer(BuildContext context, Widget destination) {
  _closeEndDrawerSafely(context);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => destination),
    );
  });
}

void _showLocationRadiusStatusDialog(
  BuildContext context, {
  dynamic officeLocation,
  dynamic currentPosition,
}) {
  _closeEndDrawerSafely(context);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;

    String officeText = 'Belum diatur di Profil Perusahaan';
    String userText = 'Posisi GPS belum terbaca';
    String distanceText = '-';

    double? officeLat;
    double? officeLng;
    double? radiusMeters;

    if (officeLocation is Map) {
      officeLat = double.tryParse(
        (officeLocation['latitude'] ?? officeLocation['lat'])?.toString() ?? '',
      );
      officeLng = double.tryParse(
        (officeLocation['longitude'] ?? officeLocation['lng'])?.toString() ??
            '',
      );
      radiusMeters = double.tryParse(
        (officeLocation['radiusMeters'] ?? officeLocation['radius'])
                ?.toString() ??
            '100',
      );
    }

    if (officeLat != null && officeLng != null) {
      officeText =
          '${officeLat.toStringAsFixed(6)}, ${officeLng.toStringAsFixed(6)} (Radius ${radiusMeters?.round() ?? 100} m)';
    }

    double? userLat;
    double? userLng;
    if (currentPosition is Position) {
      userLat = currentPosition.latitude;
      userLng = currentPosition.longitude;
    } else if (currentPosition is Map) {
      userLat = double.tryParse(
        (currentPosition['latitude'] ?? currentPosition['lat'])?.toString() ??
            '',
      );
      userLng = double.tryParse(
        (currentPosition['longitude'] ?? currentPosition['lng'])?.toString() ??
            '',
      );
    }

    if (userLat != null && userLng != null) {
      userText = '${userLat.toStringAsFixed(6)}, ${userLng.toStringAsFixed(6)}';
      if (officeLat != null && officeLng != null) {
        final double meters = Geolocator.distanceBetween(
          userLat,
          userLng,
          officeLat,
          officeLng,
        );
        final double maxRadius = radiusMeters ?? 100.0;
        final bool inside = meters <= maxRadius;
        distanceText =
            '${meters.round()} meter (${inside ? 'Di dalam radius kantor' : 'Di luar radius kantor'})';
      }
    }

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.my_location),
        title: const Text('Status Lokasi & Radius'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Titik Kantor:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(officeText),
            const SizedBox(height: 10),
            const Text(
              'Posisi Anda Saat Ini:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(userText),
            const SizedBox(height: 10),
            const Text(
              'Jarak ke Kantor:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(distanceText),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const EditCompanyPage(),
                ),
              );
            },
            child: const Text('Atur Lokasi'),
          ),
        ],
      ),
    );
  });
}

void _showAttendanceHelpDialog(BuildContext context) {
  _closeEndDrawerSafely(context);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.help_outline),
        title: const Text('Panduan Presensi Matrix Sphere'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Pastikan GPS aktif dan izin lokasi diberikan.\n'
                '2. Lakukan Check-In sesuai jam operasional kantor.\n'
                '3. Pastikan posisi berada di dalam radius yang ditentukan Admin.\n'
                '4. Lakukan Check-Out setelah jam kerja selesai.\n'
                '5. Ketuk kartu Riwayat Absensi untuk melihat kalender kehadiran.',
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  });
}

// Daftar item menu EndDrawer lengkap khusus Halaman Attendance
List<MenuDrawer> getEndDrawerItems(
  BuildContext context,
  String currentRoute, {
  dynamic officeLocation,
  dynamic currentPosition,
}) {
  return [
    MenuDrawer(
      title: 'Pengaturan Attendance',
      icon: Icons.tune,
      label:
          'Atur jam masuk/pulang, titik koordinat kantor (PIN Lock), dan batas radius.',
      route: '/edit-company',
      onTap: () => _navigateAfterClosingDrawer(
        context,
        const EditCompanyPage(),
      ),
    ),
    MenuDrawer(
      title: 'Profil & Info Kantor',
      icon: Icons.apartment_outlined,
      label:
          'Lihat profil perusahaan, jam operasional Matrix Sphere, dan titik lokasi aktif.',
      route: '/company-profile',
      onTap: () => _navigateAfterClosingDrawer(
        context,
        const CompanyProfile(),
      ),
    ),
    MenuDrawer(
      title: 'Kalender Riwayat Absensi',
      icon: Icons.calendar_month_outlined,
      label:
          'Lihat kalender kehadiran bulanan (hijau sudah absen, merah tidak absen).',
      route: '/attendance-history',
      onTap: () {
        _closeEndDrawerSafely(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          AppNavigation.openAttendanceHistory(context);
        });
      },
    ),
    MenuDrawer(
      title: 'Cek Jarak & Radius GPS',
      icon: Icons.my_location_outlined,
      label:
          'Periksa koordinat perangkat saat ini dan jarak terhadap titik kantor.',
      route: '',
      onTap: () => _showLocationRadiusStatusDialog(
        context,
        officeLocation: officeLocation,
        currentPosition: currentPosition,
      ),
    ),
    MenuDrawer(
      title: 'Pengingat Jam Kerja',
      icon: Icons.notifications_active_outlined,
      label: 'Info jadwal pengingat Check-In dan Check-Out harian.',
      route: '',
      onTap: () {
        _closeEndDrawerSafely(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pengingat mengikuti jam operasional di Pengaturan Attendance.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    ),
    MenuDrawer(
      title: 'Panduan & Bantuan',
      icon: Icons.help_outline,
      label:
          'Baca tata cara melakukan presensi, validasi radius, dan reset harian.',
      route: '',
      onTap: () => _showAttendanceHelpDialog(context),
    ),
  ];
}

List<SideMenuItem> getEndDrawerSideMenuItems(
  BuildContext context,
  String currentRoute, {
  required dynamic officeLocation,
  required dynamic currentPosition,
}) {
  final List<MenuDrawer> drawerItems = getEndDrawerItems(
    context,
    currentRoute,
    officeLocation: officeLocation,
    currentPosition: currentPosition,
  );

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