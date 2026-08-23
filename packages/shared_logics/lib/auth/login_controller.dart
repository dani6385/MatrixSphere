import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_ui/shared_ui.dart'; // Impor file dialog sebelumnya

class LoginController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool rememberMe = false;
  bool obscurePassword = true;

  // Memuat kredensial tersimpan saat halaman dibuka
  Future<void> loadSavedCredentials(VoidCallback onUpdate) async {
    final prefs = await SharedPreferences.getInstance();
    rememberMe = prefs.getBool('remember_me') ?? false;
    if (rememberMe) {
      emailController.text = prefs.getString('saved_email') ?? '';
      passwordController.text = prefs.getString('saved_password') ?? '';
    }
    onUpdate(); // Memperbarui UI setelah data dimuat
  }

  // Fungsi eksekusi Login
  Future<void> performLogin(BuildContext context, VoidCallback onSuccess) async {
    if (formKey.currentState!.validate()) {
      AppDialogs.showLoading(context, 'Sedang memproses masuk...');

      try {
        // Simulasi request API ke server
        await Future.delayed(const Duration(seconds: 2));

        final prefs = await SharedPreferences.getInstance();
        if (rememberMe) {
          await prefs.setBool('remember_me', true);
          await prefs.setString('saved_email', emailController.text);
          await prefs.setString('saved_password', passwordController.text);
        } else {
          await prefs.remove('remember_me');
          await prefs.remove('saved_email');
          await prefs.remove('saved_password');
        }

        // Simpan sandi ke Google Smart Lock jika didukung
        TextInput.finishAutofillContext();

        if (context.mounted) {
          AppDialogs.dismiss(context);
          AppDialogs.showSuccess(
            context: context,
            title: 'Berhasil',
            message: 'Selamat datang kembali!',
            onConfirm: onSuccess,
          );
        }
      } catch (e) {
        if (context.mounted) {
          AppDialogs.dismiss(context);
          AppDialogs.showError(
            context: context,
            title: 'Gagal',
            message: 'Terjadi kesalahan sistem.',
          );
        }
      }
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}