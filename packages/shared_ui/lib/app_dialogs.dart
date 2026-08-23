import 'package:flutter/material.dart';

class AppDialogs {
  // 1. Menampilkan Loading Dialog (Tanpa tombol batal)
  static void showLoading(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Pengguna tidak bisa menutup dialog dengan mengetuk luar area
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Mencegah pengguna menutup dengan tombol kembali HP
          child: AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Menutup dialog aktif (misal menutup Loading setelah proses selesai)
  static void dismiss(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // 2. Menampilkan Dialog Sukses
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                onConfirm(); // Jalankan fungsi callback (misal: pindah halaman)
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // 3. Menampilkan Dialog Gagal/Error
  static void showError({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 28),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}