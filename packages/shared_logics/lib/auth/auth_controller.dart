import 'package:flutter/material.dart';
import 'package:shared_utils/shared_utils.dart'; // Impor UI Helper/SnackBar Anda
import 'package:shared_services/shared_services.dart';

class AuthController {
  final AuthService _authService = AuthService();

  // Menangani alur login, navigasi role, dan visualisasi error SnackBar
  Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      // 1. Jalankan proses login Firebase murni dari AuthService
      final credential = await _authService.login(email, password);

      if (credential.user != null) {
        // 2. Logika pemeriksaan role pasca login sukses
        // Ambil data role pengguna dari database Anda di sini
        String role = 'admin'; // Simulasi role (silakan disesuaikan)

        if (context.mounted) {
          if (role == 'admin') {
            // Navigasi ke halaman Admin
            // NavigationService.navigateAndRemoveUntil(AppRoutes.adminHome);
          } else {
            // Navigasi ke halaman Member
            // NavigationService.navigateAndRemoveUntil(AppRoutes.memberHome);
          }
        }
      }
    } catch (e) {
      // 3. Tampilkan pesan kesalahan di UI menggunakan SnackBar
      if (context.mounted) {
        UiHelper.showSnackBar(
          context, 
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    }
  }
}