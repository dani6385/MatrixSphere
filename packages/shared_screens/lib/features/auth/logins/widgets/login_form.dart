import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_error_banner.dart';
import 'login_remember_me.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const String _prefRememberMeKey = 'auth_remember_me';
  static const String _prefSavedEmailKey = 'auth_saved_email';
  static const String _prefSavedPasswordKey = 'auth_saved_password';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Memuat kredensial tersimpan saat halaman pertama kali dibuka
  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isRemembered = prefs.getBool(_prefRememberMeKey) ?? false;

      if (isRemembered) {
        final savedEmail = prefs.getString(_prefSavedEmailKey) ?? '';
        final savedPassword = prefs.getString(_prefSavedPasswordKey) ?? '';

        if (mounted) {
          setState(() {
            _rememberMe = true;
            _emailController.text = savedEmail;
            _passwordController.text = savedPassword;
          });
        }
      }
    } catch (_) {
      // Abaikan error saat membaca preferences
    }
  }

  /// Menyimpan atau menghapus kredensial berdasarkan status 'Remember Me'
  Future<void> _saveOrClearCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setBool(_prefRememberMeKey, true);
        await prefs.setString(_prefSavedEmailKey, _emailController.text.trim());
        await prefs.setString(_prefSavedPasswordKey, _passwordController.text);
      } else {
        await prefs.setBool(_prefRememberMeKey, false);
        await prefs.remove(_prefSavedEmailKey);
        await prefs.remove(_prefSavedPasswordKey);
      }
    } catch (_) {
      // Abaikan error saat menulis preferences
    }
  }

  /// Menangani proses Login dengan validasi dan penanganan error Firebase
  Future<void> _handleLogin() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      // 1. Eksekusi Firebase Authentication
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan token sesi jika ada
      if (userCredential.user != null) {
        final token = await userCredential.user!.getIdToken();
        final prefs = await SharedPreferences.getInstance();
        if (token != null) {
          await prefs.setString('user_token', token);
        }
      }

      // 2. Simpan atau hapus kredensial jika Remember Me aktif
      await _saveOrClearCredentials();

      if (!mounted) return;

      setState(() => _isLoading = false);

      // 3. Navigasi ke halaman beranda
      context.go('/');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Akun dengan email ini tidak ditemukan.';
          break;
        case 'wrong-password':
          message = 'Kata sandi yang Anda masukkan salah.';
          break;
        case 'invalid-credential':
          message = 'Email atau kata sandi salah. Silakan periksa kembali.';
          break;
        case 'invalid-email':
          message = 'Format alamat email tidak valid.';
          break;
        case 'user-disabled':
          message = 'Akun pengguna ini telah dinonaktifkan oleh administrator.';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan gagal. Silakan coba lagi beberapa saat.';
          break;
        case 'network-request-failed':
          message = 'Koneksi internet bermasalah. Pastikan perangkat terhubung ke internet.';
          break;
        case 'channel-error':
          message = 'Mohon lengkapi email dan kata sandi Anda.';
          break;
        default:
          message = e.message ?? 'Autentikasi gagal. Silakan coba lagi.';
      }

      _displayError(message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      _displayError('Terjadi kesalahan saat masuk: ${e.toString()}');
    }
  }

  void _displayError(String message) {
    setState(() {
      _errorMessage = message;
    });

    if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Error Banner Widget ---
          if (_errorMessage != null)
            LoginErrorBanner(
              message: _errorMessage!,
              onDismiss: () => setState(() => _errorMessage = null),
            ),

          // --- Email Field ---
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'nama@example.com',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Silakan masukkan email Anda';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Format email tidak valid (contoh: nama@domain.com)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // --- Password Field ---
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            decoration: InputDecoration(
              labelText: 'Kata Sandi',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Silakan masukkan kata sandi Anda';
              }
              if (value.length < 6) {
                return 'Kata sandi minimal harus 6 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // --- Remember Me Checkbox ---
          Align(
            alignment: Alignment.centerLeft,
            child: LoginRememberMe(
              value: _rememberMe,
              onChanged: (val) {
                setState(() {
                  _rememberMe = val ?? false;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // --- Login Button ---
          FilledButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

