import 'package:flutter/material.dart';
import 'package:shared_components/shared_components.dart';
import 'package:shared_ui/shared_ui.dart';
import 'widgets/drawer_items.dart';
import 'widgets/end_drawer_items.dart';
import 'package:shared_screens/shared_screens.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  // Simulasi data persetujuan berdasarkan struktur JSON yang kamu berikan
  final Map<String, dynamic> _approvalData = {
    "toko_andika": {
      "nama": "andika",
      "status": "waiting"
    },
    // Kamu bisa menambahkan data uji coba lainnya di sini jika diperlukan
  };

  void navigateToApprovalDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          title: 'Toko Andika',
          subtitle: 'Status: Menunggu Persetujuan (Waiting)',
          details: {
            'ID Toko': 'toko_andika',
            'Pemilik': 'Andika',
            'Kategori': 'Retail / Grosir',
            'Tanggal Daftar': '31 Agustus 2026',
          },
          primaryButtonLabel: 'Setujui Toko',
          primaryButtonColor: Colors.green,
          onPrimaryAction: () {
            // Logika ketika tombol setuju ditekan
            debugPrint('Toko Andika disetujui!');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengubah Map data menjadi List agar mudah ditampilkan menggunakan ListView
    final keys = _approvalData.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Persetujuan Toko (Approval)'),
        elevation: 2,
      ),
      
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getDrawerSideMenuItems(context, currentRoute);
        },
      ),
      endDrawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getEndDrawerSideMenuItems(context, currentRoute);
        },
      ),
      body: keys.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada data persetujuan saat ini.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final shopKey = keys[index];
                final shopInfo = _approvalData[shopKey];
                final String shopName = shopInfo['nama'] ?? 'Tanpa Nama';
                final String status = shopInfo['status'] ?? 'unknown';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Informasi Toko
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID Toko: $shopKey',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Nama: $shopName',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Chip(
                                label: Text(
                                  'Status: $status',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: status == 'waiting'
                                    ? kWarmOrange.withValues(alpha: 0.2)
                                    : kSeaGreen.withValues(alpha: 0.2),
                              ),
                            ],
                          ),
                        ),

                        // Tombol Aksi (Setujui / Tolak)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Logika ketika tombol disetujui ditekan
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Menyetujui $shopName')),
                                );
                              },
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text('Setuju'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kSeaGreen,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Logika ketika tombol ditolak ditekan
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Menolak $shopName')),
                                );
                              },
                              icon: const Icon(Icons.close, size: 16),
                              label: const Text('Tolak'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: kAlertRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}