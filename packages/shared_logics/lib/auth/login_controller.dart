import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_screens/shared_screens.dart';

class LoginController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();

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
  Future<void> performLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      AppDialogs.showLoading(context, 'Sedang memproses masuk...');

      try {
        // Memanggil fungsi login dari AuthService
        final sukses = await _authService.login(
          emailController.text, 
          passwordController.text,
        );

        if (sukses) {
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

          TextInput.finishAutofillContext();

          if (context.mounted) {
            AppDialogs.dismiss(context); // Tutup loading
            
            // Pindahkan pengguna ke HomeScreen (Halaman Kosong) dan hapus tumpukan halaman sebelumnya
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          AppDialogs.dismiss(context); // Tutup loading
          AppDialogs.showError(
            context: context,
            title: 'Gagal Masuk',
            message: e.toString().replaceAll('Exception: ', ''), // Menampilkan pesan error asli
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
