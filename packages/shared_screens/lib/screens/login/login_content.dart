import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';


class LoginContent extends StatefulWidget {
  final AppType currentApp;

  const LoginContent({
    super.key,
    required this.currentApp,
  });

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  // Pengontrol untuk mengambil teks dari form input
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Judul Dinamis berdasarkan Aplikasi yang Aktif
                Text(
                  '${_getAppName(widget.currentApp)} - Login',
                  style: const TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Kolom Input Email
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

                // Kolom Input Kata Sandi
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

                // Tombol Masuk
                ElevatedButton(
                  onPressed: () {
                    // Menggunakan AppNavigation yang sudah kita buat sebelumnya
                    // untuk berpindah ke halaman utama (Home) secara dinamis
                    AppNavigation.goToHome(
                      context, 
                      appType: widget.currentApp,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Masuk', 
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Fungsi helper untuk menerjemahkan AppType menjadi teks judul yang rapi
  String _getAppName(AppType app) {
    switch (app) {
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