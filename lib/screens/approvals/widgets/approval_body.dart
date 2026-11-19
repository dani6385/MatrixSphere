// Di dalam file approval_body.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_screens/shared_screens.dart'; // Sesuaikan jalur impor file detail_screen.dart kamu

class ApprovalBody extends StatelessWidget {
  final Map<String, dynamic> approvalData;
  final Function(String shopKey, String shopName) onApprove;
  final Function(String shopKey, String shopName) onReject;

  const ApprovalBody({
    super.key,
    required this.approvalData,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final keys = approvalData.keys.toList();

    return keys.isEmpty
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
              final shopInfo = approvalData[shopKey];
              final String shopName = shopInfo['nama'] ?? 'Tanpa Nama';
              final String status = shopInfo['status'] ?? 'unknown';

              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  // KETIKA KARTU DIKLIK: Langsung arahkan ke DetailScreen lokal
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          title: 'Toko ${shopName.toUpperCase()}',
                          subtitle: 'Status: $status',
                          details: {
                            'ID Toko': shopKey,
                            'Pemilik': shopName,
                            'Status Approval': status,
                          },
                          primaryButtonLabel: 'Setujui Toko',
                          primaryButtonColor: Colors.green,
                          onPrimaryAction: () {
                            // Logika saat tombol setuju di halaman detail ditekan
                            debugPrint('Menyetujui $shopName dari detail');
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => onApprove(shopKey, shopName),
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text('Setuju'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kSeaGreen,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            OutlinedButton.icon(
                              onPressed: () => onReject(shopKey, shopName),
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
                ),
              );
            },
          );
  }
}