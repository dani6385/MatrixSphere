import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'auth_storage_service.dart';

/// Kerangka mixin logika untuk halaman login.
/// Memisahkan state, controller, penyimpanan kredensial, dan proses autentikasi
/// agar tampilan di `login_body.dart` dan `login_screen.dart` tetap ringkas.
mixin LoginLogic<T extends StatefulWidget> on State<T> {
  final Logger logger = Logger();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthStorageService storageService = AuthStorageService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordObscured = true;
  bool isLoading = false;
  bool rememberMe = false;

  /// Memuat data kredensial tersimpan (jika fitur "Ingat Saya" aktif).
  Future<void> loadSavedCredentials() async {
    final Map<String, dynamic> credentials =
        await storageService.loadCredentials();
    if (!mounted) return;

    setState(() {
      rememberMe = (credentials['rememberMe'] as bool?) ?? false;
      emailController.text = (credentials['email'] as String?) ?? '';
      passwordController.text = (credentials['password'] as String?) ?? '';
    });
  }

  /// Mengubah status tampil/sembunyi password.
  void togglePasswordVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
  }

  /// Mengubah status checkbox "Ingat Saya".
  void updateRememberMe(bool? value) {
    setState(() {
      rememberMe = value ?? false;
    });
  }

  /// Menjalankan proses masuk menggunakan Firebase Auth dan menyimpan kredensial.
  Future<void> submitLogin() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      // 1. Autentikasi email & password ke Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Simpan atau hapus kredensial lokal sesuai checkbox "Ingat Saya"
      await storageService.saveCredentials(
        rememberMe: rememberMe,
        email: email,
        password: password,
      );

      logger.i('Login berhasil untuk email: $email');
    } on FirebaseAuthException catch (e) {
      logger.w('Gagal login (Firebase): ${e.code} - ${e.message}');
      showErrorMessage(mapFirebaseAuthError(e.code));
    } catch (e) {
      logger.e('Gagal login (Umum): $e');
      showErrorMessage('Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// Menerjemahkan kode error Firebase Auth ke bahasa Indonesia.
  String mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Pengguna dengan email ini tidak ditemukan.';
      case 'wrong-password':
        return 'Password yang Anda masukkan salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan masuk. Coba lagi nanti.';
      default:
        return 'Terjadi kesalahan saat masuk.';
    }
  }

  /// Menampilkan pesan error menggunakan SnackBar.
  void showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Membersihkan controller saat widget dihapus dari tree.
  void disposeLoginControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}