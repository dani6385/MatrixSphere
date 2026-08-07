import 'package:flutter/material.dart';
import 'components/transaction_history_body.dart';

/// Layar untuk menampilkan riwayat transaksi.
class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: const TransactionHistorybody(),
    );
  }
}