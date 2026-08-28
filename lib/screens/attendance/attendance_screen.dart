import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bagian atas aplikasi (AppBar standar)
      appBar: AppBar(
        title: const Text('Halaman Absensi'),
        centerTitle: true,
      ),
      // Isi utama halaman beranda
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.home_rounded,
                size: 80,
                color: kNeonBlue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat Datang!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ini adalah halaman Home standar Flutter yang bersih dan tanpa AppType.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              // Contoh tombol interaktif sederhana
              ElevatedButton.icon(
                onPressed: () {
                  // Aksi ketika tombol ditekan (misal: kembali atau memunculkan pesan)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tombol Beranda ditekan!')),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Informasi Sistem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}