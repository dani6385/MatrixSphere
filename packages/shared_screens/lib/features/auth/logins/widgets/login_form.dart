
import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';
import 'login_error_banner.dart';
import 'login_remember_me.dart';
import 'email_input_field.dart'; // Impor komponen baru
import 'password_input_field.dart'; // Impor komponen baru
import 'login_submit_button.dart'; // Impor komponen baru

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
    final credentials = await _authService.loadSavedCredentials();
    if (mounted && credentials['rememberMe'] == true) {
      setState(() {
        _rememberMe = true;
        _emailController.text = credentials['email'];
        _passwordController.text = credentials['password'];
      });
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
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await _authController.loginUser(context as BuildContext, email, password);
      debugPrint("=== [LOG] 5. Autentikasi Firebase Berhasil ===");

      await _authService.saveOrClearCredentials(_rememberMe, email, password);
      debugPrint("=== [LOG] 6. Login berhasil, AuthGate akan menangani navigasi.");

      // Setelah login berhasil, tidak perlu melakukan navigasi manual.
      // AuthGate akan mendeteksi perubahan status otentikasi dan
      // mengarahkan pengguna secara otomatis.
      // Cukup pastikan state loading dihentikan jika widget masih ter-mount.
      if (!mounted) return;
      setState(() => _isLoading = false);

    } on FirebaseAuthException catch (e) {
      debugPrint("=== [LOG] ERROR FIREBASE: ${e.code} - ${e.message} ===");
      if (!mounted) return;
      setState(() => _isLoading = false);
      _displayError(_authService.handleAuthError(e));
    } catch (e) {
      debugPrint("=== [LOG] ERROR UMUM: ${e.toString()} ===");
      if (!mounted) return;
      setState(() => _isLoading = false);
      _displayError('Terjadi kesalahan saat masuk: ${e.toString()}');
    }
  }

  void _displayError(String message) {
    setState(() => _errorMessage = message);

    if (mounted) {
      ScaffoldMessenger.of(context as BuildContext).hideCurrentSnackBar();
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Theme.of(context as BuildContext).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
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
            onPressed: _handleLogin,
          ),
        ],
      ),
    );
  }
}