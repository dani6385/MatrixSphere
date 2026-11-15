import 'package:flutter/material.dart';

/// Halaman utama (Analytics Screen) awal yang masih kosong dan siap untuk dikembangkan.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bilah bagian atas aplikasi (AppBar)
      appBar: AppBar(
        title: const Text('Analytics'),
        elevation: 0, // Memberikan efek rata tanpa bayangan
      ),
      
      // Area utama halaman (Body)
      body: const Center(
        child: Text(
          'Halaman Beranda (Analytics)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}