// lib/screens/details/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart'; // Menggunakan ActionBottom dan ActionButton bersama

class DetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final Map<String, String> details;
  final VoidCallback onPrimaryAction;
  final String primaryButtonLabel;
  final Color? primaryButtonColor;

  const DetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.details,
    required this.onPrimaryAction,
    required this.primaryButtonLabel,
    this.primaryButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Kartu Header Informasi Utama
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Bagian Rincian Data (Dibuat Dinamis dari Map)
          const Text(
            'Informasi Lengkap',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: details.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                String key = details.keys.elementAt(index);
                String value = details[key] ?? '-';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        key,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      // Menggunakan ActionBottom dari shared_ui untuk tombol aksi di bawah
      bottomNavigationBar: ActionBottom(
        children: [
          ActionButton(
            label: primaryButtonLabel,
            icon: Icons.check_circle_outline,
            backgroundColor: primaryButtonColor ?? Colors.blue,
            onPressed: onPrimaryAction,
          ),
        ],
      ),
    );
  }
}