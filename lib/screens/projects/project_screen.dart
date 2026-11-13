import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kelas utama untuk halaman Project (hom.dart).
/// Menggunakan StatelessWidget karena halaman dasar ini belum menyimpan perubahan data internal.
class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  /// Fungsi untuk menghapus sesi login dari penyimpanan lokal (SharedPreferences)
  /// dan mengarahkan pengguna kembali ke halaman login.
  Future<void> _handleLogout(BuildContext context) async {
    // 1. Mengambil instance penyimpanan lokal
    final prefs = await SharedPreferences.getInstance();
    
    // 2. Menghapus status login yang tersimpan sebelumnya
    await prefs.remove('is_logged_in');

    // 3. Memastikan widget masih aktif di layar sebelum berpindah halaman
    if (context.mounted) {
      // Mengarahkan pengguna kembali ke rute login menggunakan GoRouter
      // Sesuaikan '/login' dengan nama path rute login di app_router.dart Anda
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bagian bilah atas aplikasi
      appBar: AppBar(
        title: const Text('Project'),
        centerTitle: true,
        actions: [
          // Tombol contoh untuk keluar (Logout)
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      
      // Bagian isi utama halaman (area kosongan yang siap diisi widget Anda)
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard_customize_outlined,
                  size: 64,
                  color: Colors.blueGrey,
                ),
                SizedBox(height: 16),
                Text(
                  'Selamat Datang di Matrix Sphere!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Ini adalah kerangka halaman hom.dart yang siap Anda kembangkan.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}