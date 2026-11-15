import 'package:flutter/material.dart';

/// Halaman utama (Project Screen) awal yang masih kosong dan siap untuk dikembangkan.
class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bilah bagian atas aplikasi (AppBar)
      appBar: AppBar(
        title: const Text('Project'),
        elevation: 0, // Memberikan efek rata tanpa bayangan
      ),
      
      // Area utama halaman (Body)
      body: const Center(
        child: Text(
          'Halaman Beranda (Project)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}