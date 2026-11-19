import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_storage_service.dart';
import 'login_form_widgets.dart';

final Logger _logger = Logger();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storageService = AuthStorageService(); // Memanggil layanan penyimpanan

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadCredentialsToForm();
  }

  /// Memuat data tersimpan menggunakan AuthStorageService
  Future<void> _loadCredentialsToForm() async {
    final credentials = await _storageService.loadCredentials();
    if (!mounted) return;

    setState(() {
      _rememberMe = credentials['rememberMe'] as bool;
      _emailController.text = credentials['email'] as String;
      _passwordController.text = credentials['password'] as String;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        // 1. Proses autentikasi Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 2. Simpan atau hapus data kredensial sesuai status checkbox
        await _storageService.saveCredentials(
          rememberMe: _rememberMe,
          email: email,
          password: password,
        );

        _logger.i('Login berhasil untuk email: $email');
      } on FirebaseAuthException catch (e) {
        _logger.w('Gagal login (Firebase): ${e.code} - ${e.message}');
        _showErrorSnackBar(_mapFirebaseError(e.code));
      } catch (e) {
        _logger.e('Gagal login (Umum): $e');
        _showErrorSnackBar('Terjadi kesalahan: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  /// Menerjemahkan kode error Firebase ke bahasa Indonesia
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Pengguna dengan email ini tidak ditemukan.';
      case 'wrong-password':
        return 'Password yang Anda masukkan salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      default:
        return 'Terjadi kesalahan saat masuk.';
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Komponen 1: Header
                  const LoginHeader(),
                  const SizedBox(height: 32),

                  // Komponen 2: Input Email & Password
                  LoginInputFields(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isPasswordObscured: _isPasswordObscured,
                    onTogglePasswordVisibility: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Checkbox "Ingat Saya"
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Ingat Saya'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tombol Masuk
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Masuk', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}