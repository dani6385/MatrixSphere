import 'package:flutter/material.dart';
import 'widgets/open_end_drawer.dart';
import 'package:shared_ui/shared_ui.dart';

/// Halaman utama (Home Screen) awal yang masih kosong dan siap untuk dikembangkan.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bilah bagian atas aplikasi (AppBar)
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0, // Memberikan efek rata tanpa bayangan
      ),
      endDrawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getEndDrawerSideMenuItems(context, currentRoute);
        },
      ),
      // Area utama halaman (Body)
      // Area utama halaman (Body)
      body: const Center(
        child: Text(
          'Halaman Beranda (Home)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}