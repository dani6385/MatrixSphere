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
      endDrawer: SideMenu(
        header: const UserAccountsDrawerHeader(
          accountName: Text('Nama Pengguna'),
          accountEmail: Text('user@email.com'),
          currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
        ),
        items: [
          // Daftar menu item lainnya di sini...
        ],
        // Menempatkan tombol logout di bagian bawah drawer
        footer: const OpenEndDrawer(),
        selectedRoute: '/home',
        children: const [],
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