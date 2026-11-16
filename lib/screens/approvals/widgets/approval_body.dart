import 'package:flutter/material.dart';

/// Kerangka dasar tampilan utama (Body) untuk halaman Approval yang masih kosong
/// dan siap untuk dikembangkan lebih lanjut.
class ApprovalBody extends StatelessWidget {
  const ApprovalBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Persetujuan (Approvals)',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}