import 'package:flutter/material.dart';

/// Kerangka dasar tampilan utama (Body) untuk halaman Project yang masih kosong
/// dan siap untuk dikembangkan lebih lanjut.
class ProjectBody extends StatelessWidget {
  const ProjectBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Proyek (Projects)',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}