import 'package:flutter/material.dart';

/// Layar umum untuk fitur manajemen.
///
/// Ini adalah contoh layar manajemen yang dapat diperluas untuk
/// menampilkan berbagai opsi atau ringkasan manajemen.
class ManagementAppBarScreen extends StatelessWidget {
  const ManagementAppBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen'), // Judul untuk layar manajemen umum
        centerTitle: true,
        // Ikon untuk endDrawer (kanan)
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.person_outline),
              tooltip: 'Menu',
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      // Drawer (menu samping kiri)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu Utama'),
            ),
            ListTile(title: Text('Item 1')),
            ListTile(title: Text('Item 2')),
          ],
        ),
      ),
      // EndDrawer (menu samping kanan)
      endDrawer: const Drawer(
        child: Center(child: Text('Konten Profil atau Notifikasi')),
      ),
      body: const Center(
        child: Text('Konten manajemen'),
      ),
    );
  }
}