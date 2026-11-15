import 'package:flutter/material.dart';

/// Halaman utama (Attendance Screen) awal yang masih kosong dan siap untuk dikembangkan.
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bilah bagian atas aplikasi (AppBar)
      appBar: AppBar(
        title: const Text('Attendance'),
        elevation: 0, // Memberikan efek rata tanpa bayangan
      ),
      
      // Area utama halaman (Body)
      body: const Center(
        child: Text(
          'Halaman Beranda (Attendance)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}