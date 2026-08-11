import 'package:flutter/material.dart';
import 'package:seller_sphere/navigations/app_navigation.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _shopNameController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // 1. Buat akun pengguna di Firebase Auth
        final userCredential = await _authService.createUserAccount(
          _emailController.text.trim(),
          _passwordController.text,
        );
        final user = userCredential.user;
        if (user == null) throw Exception("Gagal membuat akun, coba lagi.");

        // 2. Buat entri toko awal di Realtime Database
        await _authService.createInitialShopEntry(
          user: user,
          shopName: _shopNameController.text.trim(),
        );

        // 3. Arahkan ke layar registrasi toko untuk melengkapi detail
        if (mounted) {
          AppNavigation.goToShopRegister(context);
        }
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      showErrorDialog(
          context: context, message: message.replaceAll("Exception: ", ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pendaftaran Penjual')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Langkah 1: Buat Akun & Nama Toko',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    (value == null || !value.contains('@'))
                        ? 'Masukkan email yang valid'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) => (value == null || value.length < 6)
                    ? 'Password minimal 6 karakter'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => setState(() =>
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
                validator: (value) =>
                    (value != _passwordController.text) ? 'Password tidak cocok' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _shopNameController,
                decoration: const InputDecoration(labelText: 'Nama Toko'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Nama toko tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleRegister,
                      child: const Text('Lanjut ke Detail Toko'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}