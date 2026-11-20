import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// 1. Komponen Header di bagian atas halaman Login.
class LoginHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const LoginHeader({
    super.key,
    this.title = 'Selamat Datang',
    this.subtitle = 'Silakan masuk ke akun Anda',
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        const Icon(
          Icons.lock_person_rounded,
          size: 80,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// 2. Komponen Input Email dan Password menggunakan `CustomTextField` dari `shared_ui`.
/// Menyediakan fitur lihat/sembunyikan password melalui `isPasswordObscured`
/// dan callback `onTogglePasswordVisibility`.
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
        // Kolom Input Email
        CustomTextField(
          controller: emailController,
          labelText: 'Email',
          hintText: 'Masukkan email Anda',
          prefixIcon: const Icon(Icons.email_outlined),
          suffixIcon: IconButton(
            tooltip: 'Hapus email',
            icon: const Icon(Icons.clear),
            onPressed: () => emailController.clear(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            final String trimmed = value?.trim() ?? '';
            if (trimmed.isEmpty) {
              return 'Email tidak boleh kosong';
            }
            if (!trimmed.contains('@') || !trimmed.contains('.')) {
              return 'Format email tidak valid';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Kolom Input Password dengan tombol ikon mata (lihat / sembunyikan)
        CustomTextField(
          controller: passwordController,
          labelText: 'Password',
          hintText: 'Masukkan password Anda',
          prefixIcon: const Icon(Icons.lock_outline),
          obscureText: isPasswordObscured,
          suffixIcon: IconButton(
            tooltip: isPasswordObscured
                ? 'Tampilkan password'
                : 'Sembunyikan password',
            icon: Icon(
              isPasswordObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey[700],
            ),
            onPressed: onTogglePasswordVisibility,
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