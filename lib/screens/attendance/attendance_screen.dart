import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  // ==========================================
  // [!] MASUKKAN KOORDINAT KANTOR ANDA DI SINI
  // ==========================================
  static const double officeLatitude = -6.200000; // Contoh: Latitude kantor Matrix Sphere
  static const double officeLongitude = 106.816666; // Contoh: Longitude kantor Matrix Sphere
  static const double maxAttendanceRadius = 50.0; // Maksimal jarak untuk bisa absen (dalam meter)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kehadiran / Absensi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Absensi Matrix Sphere',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Koordinat Kantor: $officeLatitude, $officeLongitude\n'
              'Batas Jarak: $maxAttendanceRadius meter',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                
                // dan menghitung jaraknya dengan lokasi kantor akan dibuat di sini.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mengecek lokasi Anda... (Belum diimplementasi)')),
                );
              },
              child: const Text('Absen Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}