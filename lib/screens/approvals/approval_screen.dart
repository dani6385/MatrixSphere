import 'package:flutter/material.dart';

/// Halaman utama (Approval Screen) awal yang masih kosong dan siap untuk dikembangkan.
class ApprovalScreen extends StatelessWidget {
  const ApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bilah bagian atas aplikasi (AppBar)
      appBar: AppBar(
        title: const Text('Approval'),
        elevation: 0, // Memberikan efek rata tanpa bayangan
      ),
      
      // Area utama halaman (Body)
      body: const Center(
        child: Text(
          'Halaman Beranda (Approval)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}