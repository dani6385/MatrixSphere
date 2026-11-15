import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

final Logger _logger = Logger();

/// Widget laci navigasi samping (Drawer/EndDrawer) dengan menu lengkap
class OpenEndDrawer extends StatelessWidget {
  const OpenEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Membatasi lebar drawer agar proporsional di layar perangkat
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        backgroundColor: kDarkSurface, // Warna latar belakang dari shared_ui
        child: Column(
          children: [
            // 1. Header Akun / Profil Pengguna (Bagian Atas)
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: kBrandPrimary,
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              accountName: const Text(
                'Pengguna MatrixSphere',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text('user@matrixsphere.com'),
            ),

            // 2. Daftar Menu Navigasi (Dibungkus Expanded agar mengisi ruang tengah)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined, color: Colors.white70),
                    title: const Text('Beranda', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      context.goToHome();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_outline, color: Colors.white70),
                    title: const Text('Profil Saya', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      context.goToProfile();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined, color: Colors.white70),
                    title: const Text('Pengaturan', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      context.goToSettings();
                    },
                  ),
                ],
              ),
            ),

            // 3. Garis Pemisah & Tombol Keluar (Logout) di Bagian Paling Bawah
            const Divider(color: Colors.grey, height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Keluar (Logout)',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                try {
                  // Keluar dari sesi Firebase Auth
                  await FirebaseAuth.instance.signOut();
                  _logger.i('Pengguna berhasil logout.');

                  if (!context.mounted) return;
                  Navigator.pop(context);

                  // Arahkan kembali ke halaman login
                  context.goToLogin();
                } catch (e) {
                  _logger.e('Gagal melakukan logout: $e');
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal logout: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            // Berikan sedikit ruang aman di bagian paling bawah perangkat (safe area)
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}