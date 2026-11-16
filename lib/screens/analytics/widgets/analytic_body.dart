import 'package:flutter/material.dart';

/// Kerangka dasar tampilan utama (Body) untuk halaman Analytic yang masih kosong
/// dan siap untuk dikembangkan lebih lanjut.
class AnalyticBody extends StatelessWidget {
  const AnalyticBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Analitik (Analytics)',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}