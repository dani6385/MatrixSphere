import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logika logout: Kembali ke halaman login
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          'Halaman Kosong Berhasil Terbuka',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}