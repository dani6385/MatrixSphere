import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// 1. Impor pustaka Firebase Realtime Database dan UI-nya
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:shared_ui/shared_ui.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  bool _isLoading = false;
  String _statusMessage = 'Memantau status Shop & Seller...';

  // Fungsi simulasi untuk memeriksa kendala pada modul Shop atau Seller
  Future<void> _periksaKendalaModul() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Menghubungkan ke server untuk memeriksa kendala...';
    });

    try {
      // 1. Catat event analitik bahwa pemeriksaan kendala sedang dijalankan
      await FirebaseAnalytics.instance.logEvent(
        name: 'periksa_kendala_modul_dijalankan',
      );

      // Simulasi pengecekan data
      await Future.delayed(const Duration(seconds: 2));

      // Contoh simulasi jika ingin memicu error untuk Crashlytics:
      // throw Exception('Koneksi ke modul Seller/Shop terputus');

      setState(() {
        _statusMessage = 'Semua sistem Shop & Seller berjalan normal.';
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      // 2. Tangkap error dan kirimkan ke Firebase Crashlytics
      FirebaseCrashlytics.instance
          .log("Kendala terdeteksi pada ProjectScreen (Shop/Seller)");
      FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);

      setState(() {
        _statusMessage =
            'Terdeteksi kendala pada sistem. Laporan telah dikirim.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Referensi query ke node crashes di RTDB
    final Query crashQuery = FirebaseDatabase.instance.ref().child('crashes');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Kendala Shop & Seller'),
      ),
      body: Column(
        children: [
          // Bagian Atas: Tombol dan Status Pemeriksaan Manual
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Icon(
                  Icons.monitor_heart,
                  size: 48,
                  color: kBlueAccent,
                ),
                const SizedBox(height: 8),
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _periksaKendalaModul,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Periksa Kendala Shop & Seller'),
                      ),
              ],
            ),
          ),
          const Divider(thickness: 2),
          // Bagian Bawah: Daftar Riwayat Kendala (Crashes) dari Realtime Database secara Real-Time
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Laporan Kendala (RTDB):',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: crashQuery,
              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                final jsonVal = snapshot.value as Map<dynamic, dynamic>? ?? {};
                final String modul = jsonVal['modul'] ?? 'Tidak diketahui';
                final String pesan = jsonVal['pesanError'] ?? 'Tidak ada pesan error';
                final String waktu = jsonVal['waktu'] ?? '-';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.error_outline, color: kError),
                    title: Text('Modul: $modul', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text('Pesan: $pesan', style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 2),
                        Text('Waktu: $waktu', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}