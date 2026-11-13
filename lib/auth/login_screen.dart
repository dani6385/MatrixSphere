import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan selalu mengembalikan Scaffold agar layar tidak putih kosong
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - Matrix Sphere'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selamat Datang di Matrix Sphere',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Aksi tombol login di sini
                },
                child: const Text('Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}