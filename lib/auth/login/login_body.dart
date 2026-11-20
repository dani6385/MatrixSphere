import 'package:flutter/material.dart';

import '../../../navigations/app_navigation.dart';
import 'login_form_widgets.dart';

/// Kerangka body halaman login.
/// Menerima controller dan callback dari `LoginScreen` agar fokus pada layout UI.
class LoginBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordObscured;
  final bool isLoading;
  final bool rememberMe;
  final bool isMatrixSphere;
  final bool enableShopRegistration;
  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onSubmitLogin;

  const LoginBody({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordObscured,
    required this.isLoading,
    required this.rememberMe,
    required this.isMatrixSphere,
    required this.enableShopRegistration,
    required this.onTogglePasswordVisibility,
    required this.onRememberMeChanged,
    required this.onSubmitLogin,
  });

  @override
  Widget build(BuildContext context) {
    final bool isChildApp = !isMatrixSphere;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Login
                  const LoginHeader(),
                  const SizedBox(height: 32),

                  // 2. Input Email & Password (dengan toggle lihat/sembunyi password)
                  LoginInputFields(
                    emailController: emailController,
                    passwordController: passwordController,
                    isPasswordObscured: isPasswordObscured,
                    onTogglePasswordVisibility: onTogglePasswordVisibility,
                  ),
                  const SizedBox(height: 12),

                  // 3. Checkbox "Ingat Saya" + tautan "Lupa Password" (khusus anak aplikasi)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: isLoading ? null : onRememberMeChanged,
                          ),
                          const Text('Ingat Saya'),
                        ],
                      ),
                      if (isChildApp)
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => AppNavigation.openForgotPassword(context),
                          child: const Text('Lupa Password?'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. Tombol Utama "Masuk"
                  ElevatedButton(
                    onPressed: isLoading ? null : onSubmitLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Masuk',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),

                  // 5. Opsi khusus Anak Aplikasi (tidak muncul pada Matrix Sphere)
                  if (isChildApp) ...[
                    const SizedBox(height: 12),

                    // Metode Login
                    OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => AppNavigation.goToLoginOption(context),
                      icon: const Icon(Icons.login_outlined),
                      label: const Text('Metode Login Lainnya'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),

                    const Text(
                      'Belum punya akun?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    // User Register
                    TextButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => AppNavigation.openUserRegistration(context),
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                      label: const Text('Daftar Pengguna Baru'),
                    ),

                    // Shop Register
                    if (enableShopRegistration)
                      TextButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => AppNavigation.openShopRegistration(context),
                        icon: const Icon(Icons.storefront_outlined),
                        label: const Text('Daftar Toko'),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}