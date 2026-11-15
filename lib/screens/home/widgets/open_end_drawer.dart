import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';

final Logger _logger = Logger();

/// Widget laci navigasi samping (Drawer/EndDrawer) dengan menu lengkap
class OpenEndDrawer extends StatelessWidget {
  const OpenEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan SizedBox untuk mengatur lebar drawer agar proporsional
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Drawer(
        backgroundColor: kDarkSurface, // Menggunakan warna dari shared_ui
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 1. Header Akun / Profil Pengguna
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

            // 2. Daftar Menu Navigasi Utama
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Colors.white70),
              title: const Text('Beranda', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                context.go('/home');    // Arahkan ke rute beranda
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.white70),
              title: const Text('Profil Saya', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Contoh navigasi ke halaman profil (sesuaikan rutenya)
                context.goToProfile(); // Menggunakan ekstensi kustom untuk navigasi
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: Colors.white70),
              title: const Text('Pengaturan', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                context.goToSettings(); // Menggunakan ekstensi kustom untuk navigasi
              },
            ),
            
            const Divider(color: Colors.grey, indent: 16, endIndent: 16),

            // 3. Tombol Keluar (Logout)
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

                  // Tutup drawer terlebih dahulu
                  if (!context.mounted) return;
                  Navigator.pop(context);

                  // Arahkan kembali ke halaman login
                  context.go('/login');
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
          ],
        ),
      ),
    );
  }
}