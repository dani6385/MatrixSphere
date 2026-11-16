import 'package:flutter/material.dart';

/// Kerangka dasar tampilan utama (Body) untuk halaman Attendance yang masih kosong
/// dan siap untuk dikembangkan lebih lanjut.
class AttendanceBody extends StatelessWidget {
  const AttendanceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Kehadiran (Attendances)',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}