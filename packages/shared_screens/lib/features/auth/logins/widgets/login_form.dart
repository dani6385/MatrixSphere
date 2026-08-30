import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_error_banner.dart';
import 'login_remember_me.dart';
import 'email_input_field.dart';
import 'password_input_field.dart';
import 'login_submit_button.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_logics/shared_logics.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthService _authService = AuthService();
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCredentials() async {
    try {
      final credentials = await _authService.loadSavedCredentials();
      if (mounted && credentials['rememberMe'] == true) {
        setState(() {
          _rememberMe = true;
          _emailController.text = credentials['email'] ?? '';
          _passwordController.text = credentials['password'] ?? '';
        });
      }
    } catch (e) {
      debugPrint("=== [LOG] Gagal memuat kredensial tersimpan: $e ===");
    }
  }

  Future<void> _handleLogin() async {
    debugPrint("=== [LOG] 1. Tombol Masuk Diketuk ===");
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      debugPrint("=== [LOG] 2. Validasi Form Gagal ===");
      return;
    }
    debugPrint("=== [LOG] 3. Validasi Form Berhasil ===");

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Panggil controller login
      await _authController.loginUser(context, email, password);
      debugPrint("=== [LOG] 5. Autentikasi Firebase Berhasil ===");

      await _authService.saveOrClearCredentials(_rememberMe, email, password);
      debugPrint(
          "=== [LOG] 6. Kredensial diperbarui sesuai opsi Remember Me ===");

      if (!mounted) return;
      setState(() => _isLoading = false);
      if (context.mounted) {
        context.go('/home'); // Sesuaikan '/' dengan rute halaman home / dashboard Anda
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("=== [LOG] ERROR FIREBASE: ${e.code} - ${e.message} ===");
      if (!mounted) return;
      setState(() => _isLoading = false);
      _displayError(_authService.handleAuthError(e));
    } catch (e) {
      debugPrint("=== [LOG] ERROR UMUM: ${e.toString()} ===");
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Menampilkan pesan error yang lebih aman dari TypeError mentah
      _displayError(
          'Terjadi kesalahan saat masuk. Periksa kembali koneksi atau data Anda.');
    }
  }

  void _displayError(String message) {
    if (!mounted) return;
    setState(() => _errorMessage = message);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_errorMessage != null)
            LoginErrorBanner(
              message: _errorMessage!,
              onDismiss: () => setState(() => _errorMessage = null),
            ),
          const SizedBox(height: 16),
          EmailInputField(controller: _emailController),
          const SizedBox(height: 16),
          PasswordInputField(
            controller: _passwordController,
            onSubmitted: _handleLogin,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: LoginRememberMe(
              value: _rememberMe,
              onChanged: (val) => setState(() => _rememberMe = val ?? false),
            ),
          ),
          const SizedBox(height: 16),
          LoginSubmitButton(
            isLoading: _isLoading,
            onPressed: _isLoading ? () {} : () => _handleLogin(),
          ),
        ],
      ),
    );
  }
}
