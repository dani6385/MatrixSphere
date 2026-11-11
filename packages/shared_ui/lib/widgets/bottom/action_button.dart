// lib/src/action_button.dart (atau sesuaikan dengan struktur folder shared_ui kamu)

import 'package:flutter/material.dart';
// Sesuaikan jika ada file styles terkait

class ActionButton extends StatelessWidget {
  /// Teks yang akan ditampilkan di dalam tombol
  final String label;

  /// Icon yang akan ditampilkan di sebelah kiri teks tombol
  final IconData icon;

  /// Fungsi yang akan dijalankan saat tombol ditekan
  final VoidCallback onPressed;

  /// Warna latar belakang tombol (opsional)
  final Color? backgroundColor;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      // Menggunakan gaya dari AppStyles jika tersedia, atau mengaturnya secara dinamis
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}