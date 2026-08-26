import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

class LoginScreen extends StatefulWidget {
  /// Menentukan aplikasi mana yang sedang aktif saat ini (dinamis untuk monorepo)
  final AppType currentApp;

  const LoginScreen({super.key, required this.currentApp});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk mengambil teks dari input form
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nameOfApp} - Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Judul atau Logo Sederhana
                  const Text(
                    'Selamat Datang Kembali',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Input Email
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Input Kata Sandi
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Kata Sandi',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  // Tombol Masuk (Login)
                  ElevatedButton(
                    onPressed: () {
                      // Logika ketika tombol masuk ditekan
                      // Contoh memanggil navigasi ke halaman Home secara dinamis menggunakan currentApp
                      AppNavigation.goToHome(
                        context,
                        appType: widget.currentApp,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Masuk', style: TextStyle(fontSize: 16)),
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

/// Ekstensi kecil untuk mengubah AppType menjadi String Judul yang rapi
extension on LoginScreen {
  String get nameOfApp {
    switch (currentApp) {
      case AppType.matrixSphere:
        return 'Matrix Sphere';
      case AppType.sellerSphere:
        return 'Seller Sphere';
      case AppType.shopSphere:
        return 'Shop Sphere';
      case AppType.adminMikrotik:
        return 'Admin Mikrotik';
      case AppType.clientConnectivity:
        return 'Client Connectivity';
    }
  }
}
