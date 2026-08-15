import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_logics/shared_logics.dart'; // Impor untuk LoginFormFields
import 'widgets/login_body.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Buat semua state yang diperlukan untuk LoginFormFields
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    // Jangan lupa untuk membersihkan controller saat widget tidak lagi digunakan
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 2. Buat fungsi callback yang akan dijalankan
  void _login() {
    // Validasi form sebelum melanjutkan
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Di sini Anda akan memanggil logika otentikasi Anda
      // Misalnya: context.read<AuthService>().login(...)
      if (kDebugMode) {
        print('Proses Login untuk: ${_emailController.text}');
      }

      // Simulasi pemanggilan jaringan
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _onRememberMeChanged(bool? newValue) {
    setState(() {
      _rememberMe = newValue ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3. Buat instance dari widget LoginFormFields dengan semua state yang diperlukan
    final loginForm = LoginFormFields(
      formKey: _formKey,
      isLoading: _isLoading,
      emailController: _emailController,
      passwordController: _passwordController,
      isPasswordVisible: _isPasswordVisible,
      rememberMe: _rememberMe,
      onLoginPressed: _login,
      onTogglePasswordVisibility: _togglePasswordVisibility,
      onRememberMeChanged: _onRememberMeChanged,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Tambahkan padding untuk estetika yang lebih baik
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const LoginHeader(),
                const SizedBox(height: 32),

                // 4. Berikan widget loginForm yang sudah jadi ke LoginBody
                LoginBody(
                  onLogin: _login, // Berikan fungsi login yang sama
                  formFields: loginForm, // Ini sekarang memiliki tipe yang benar
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
