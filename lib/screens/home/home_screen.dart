import 'package:flutter/material.dart';

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