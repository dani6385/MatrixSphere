// lib/screens/management/components/management_summary_card.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class ManagementSummaryCard extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onScanPressed;

  const ManagementSummaryCard({
    super.key,
    required this.totalPrice,
    required this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontSize: 20)),
                Text(
                  formatCurrency(totalPrice),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Pindai Produk'),
                    onPressed: onScanPressed,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}