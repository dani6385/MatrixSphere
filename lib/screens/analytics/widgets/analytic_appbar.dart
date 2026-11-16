
// lib/features/attendance/presentation/widgets/attendance_app_bar.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AnalyticAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AnalyticAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    

    return AppBar(
      // Latar belakang transparan agar gradient dari body terlihat.
      backgroundColor: Colors.transparent,
      elevation: 0,

      // Tombol di sebelah kiri untuk membuka Drawer utama (navigasi presensi)
      leading: IconButton(
        icon: Icon(
          Icons.bar_chart, // Ikon sidik jari khusus halaman attendance
          color: context.onSurface,
        ),
        tooltip: 'Menu Navigasi',
        onPressed: () {
          // Membuka Drawer dari sisi kiri
          Scaffold.of(context).openDrawer();
        },
      ),

      // Judul AppBar.
      title: Text(
        'Halaman Awal',
        style: TextStyle(
          color: context.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,

      // Tombol di sebelah kanan (actions) untuk membuka EndDrawer (kalender/riwayat)
      actions: [
        IconButton(
          icon: Icon(
            Icons.insights, // Ikon kalender untuk riwayat/jadwal kerja
            color: context.onSurface,
          ),
          tooltip: 'Pengaturan',
          onPressed: () {
            // Membuka EndDrawer dari sisi kanan
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}