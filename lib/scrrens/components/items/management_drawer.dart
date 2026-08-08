import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Layar umum untuk fitur manajemen.
///
/// Ini adalah contoh layar manajemen yang dapat diperluas untuk
/// menampilkan berbagai opsi atau ringkasan manajemen.
class ManagementDrwaer extends StatelessWidget {
  const ManagementDrwaer({super.key});  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu Utama'),
          ),
          ListTile(title: const Text('Product'), 
          onTap: () {
            // Menutup drawer sebelum navigasi
            Navigator.pop(context);
            // Navigasi ke halaman produk
            context.push('/products');
          }),
          const ListTile(title: Text('Item 2')),
        ],
      ),
    );
  }
}
