import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Halaman Scanner
///
/// Halaman ini berfungsi untuk memindai kode produk (misalnya barcode atau QR code).
/// Setelah berhasil memindai, akan mengembalikan string kode yang dipindai.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // Placeholder untuk hasil pindaian
  String _scannedCode = 'Belum ada kode dipindai';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pindai Produk'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Arahkan kamera ke barcode atau QR code produk.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            // Tombol simulasi pindaian untuk tujuan pengembangan
            ElevatedButton(
              onPressed: () {
                // Simulasi hasil pindaian
                const dummyProductId = 'PROD-001'; // Contoh ID produk
                setState(() {
                  _scannedCode = 'Kode dipindai: $dummyProductId';
                });
                // Mengembalikan hasil pindaian ke halaman sebelumnya
                context.pop(dummyProductId);
              },
              child: const Text('Simulasikan Pindaian (PROD-001)'),
            ),
            const SizedBox(height: 20),
            Text(
              _scannedCode,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}