// lib/features/auth/login/login_logic.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class LoginLogic {
  final AuthService _authService = AuthService();

  /// Memeriksa status login awal pengguna via Firebase
  Future<void> initSession({
    required void Function(bool isLoading) setLoading,
    required VoidCallback onLoggedIn,
  }) async {
    final isLoggedIn = _authService.isLoggedIn();
    if (isLoggedIn) {
      if (kDebugMode) {
        print(
            'User is already logged in via Firebase. Navigating via GoRouter.');
      }
      onLoggedIn();
    } else {
      setLoading(false);
    }
  }

  /// Memproses fungsi login menggunakan Firebase
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required void Function(bool isLoading) setLoading,
    required bool rememberMe,
  }) async {
    setLoading(true);

    try {
      // Panggil AuthService untuk login
      await _authService.login(email, password);

      // Jika login berhasil, kelola kredensial berdasarkan pilihan 'Remember Me'
      if (rememberMe) {
        await LocalAuthStorage.saveCredentials(email, password);
      } else {
        await LocalAuthStorage.clearCredentials();
      }

      if (kDebugMode) {
        print('Login successful! Firebase user authenticated.');
      }
    } on Exception catch (e) {
      if (!context.mounted) return;

      final errorStr = e.toString().toLowerCase();

      // Deteksi apakah akun belum terdaftar (user-not-found)
      if (errorStr.contains('user-not-found') || errorStr.contains('akun tidak ditemukan')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun belum terdaftar. Silakan lakukan pendaftaran terlebih dahulu.'),
          ),
        );

        // Arahkan pengguna ke halaman registrasi (Sesuaikan rute GoRouter kamu)
        // Contoh menggunakan GoRouter:
        // context.go('/register');
        // Atau menggunakan Named Route standar:
        // Navigator.pushNamed(context, '/register');
        
        setLoading(false);
        return; // Hentikan eksekusi agar pesan standar tidak muncul
      }

      // Tampilkan error umum lainnya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Login failed: ${e.toString().replaceAll("Exception: ", "")}')),
      );
    }

    if (context.mounted) {
      setLoading(false);
    }
  }
}
