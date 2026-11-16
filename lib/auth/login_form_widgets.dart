import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart'; // Mengimpor komponen dari shared_ui[cite: 6]

/// 1. Bagian Header / Judul Halaman Login
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.lock_person_rounded, size: 80, color: Colors.blue),
        const SizedBox(height: 16),
        Text(
          'Selamat Datang',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Silakan masuk ke akun Anda',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

/// 2. Bagian Input Email dan Password Menggunakan CustomTextField dari shared_ui
class LoginInputFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordObscured;
  final VoidCallback onTogglePasswordVisibility;

  const LoginInputFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordObscured,
    required this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input Email menggunakan CustomTextField
        CustomTextField(
          controller: emailController,
          labelText: 'Email',
          hintText: 'masukkan email Anda',
          prefixIcon: const Icon(Icons.email_outlined),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => emailController.clear(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email tidak boleh kosong';
            }
            if (!value.contains('@')) {
              return 'Format email tidak valid';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Input Password menggunakan CustomTextField
        // Di dalam file login_form_widgets.dart, pastikan bagian Password seperti ini:
        CustomTextField(
          controller: passwordController,
          labelText: 'Password',
          hintText: 'masukkan password Anda',
          prefixIcon: const Icon(Icons.lock_outline),
          obscureText:
              isPasswordObscured, // Mengontrol bintang-bintang password
          // Memastikan suffixIcon (tombol mata) terpasang di sini secara eksplisit
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordObscured ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed:
                onTogglePasswordVisibility, // Memanggil fungsi pembalik status
          ),

          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            if (value.length < 6) {
              return 'Password minimal 6 karakter';
            }
            return null;
          },
        ),
      ],
    );
  }
}
