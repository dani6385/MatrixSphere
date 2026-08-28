// Disimpan di direktori: lib/controllers/auth_controller.dart
import 'package:flutter/src/widgets/framework.dart';

class AuthController {
  
  // Logika login hardcode (bypass Firebase sepenuhnya untuk uji coba)
  Future<Map<String, dynamic>> validateAndLogin(
      String email, String password) async {
    try {
      print("=== [HARDCODE] Login dimulai untuk email: $email == /n");

      // Simulasi jeda jaringan sejenak (opsional)
      await Future.delayed(const Duration(milliseconds: 500));

      // Validasi hardcode sederhana (misal: cek apakah email tidak kosong)
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email dan Password tidak boleh kosong.');
      }

      // Langsung kembalikan sukses dengan role admin/member secara hardcode
      print("=== [HARDCODE] Login berhasil, mengembalikan data dummy ===");
      return {
        'success': true, 
        'role': 'admin' // Bisa diubah jadi 'member' jika ingin menguji role lain
      };

    } catch (e, stackTrace) {
      print("=== [HARDCODE] ERROR MENTAH: $e ===");
      print("=== [HARDCODE] STACKTRACE: $stackTrace ===");
      rethrow;
    }
  }

  String handleAuthError(dynamic e) {
    return e.toString();
  }

  Future<void> loginUser(
      BuildContext context, String email, String password) async {}
}