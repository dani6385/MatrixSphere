import 'package:flutter/material.dart';
import 'package:shared_logics/shared_logics.dart';
import 'package:shared_models/shared_models.dart';
import 'package:shared_components/shared_components.dart';

enum AppType { seller, shop, client, admin, matrix }

class LoginScreen extends StatefulWidget {
  final AppType appType;

  const LoginScreen({super.key, required this.appType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = LoginController();

  @override
  void initState() {
    super.initState();
    _controller.loadSavedCredentials(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logika Bersyarat: Tampilkan opsi tambahan jika BUKAN aplikasi Matrix
    final showExtras = widget.appType != AppType.matrix;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Masuk Aplikasi ${widget.appType.name.toUpperCase()}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Form Login Utama
                LoginForm(controller: _controller),
                const SizedBox(height: 24),
                
                // Tombol Login Utama
                ElevatedButton(
                  onPressed: () {
                    _controller.performLogin(context, () {
                      // Logika sukses login (pindah halaman)
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 24),

                // Tampilkan Google Login & Opsi Daftar jika bukan proyek Matrix
                if (showExtras) ...[
                  const OptionsButtons(),
                  const SizedBox(height: 32),
                  const RegisterOption(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}