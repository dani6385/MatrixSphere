// lib/features/presentations/transactions/transaction_history_body.dart

import 'package:flutter/material.dart';
import 'transaction_model.dart';
import 'transaction_card.dart';

/// Halaman untuk menampilkan riwayat transaksi[cite: 5].
class TransactionHistorybody extends StatefulWidget {
  const TransactionHistorybody({super.key});

  @override
  State<TransactionHistorybody> createState() =>
      _TransactionHistorybodyState();
}

class _TransactionHistorybodyState extends State<TransactionHistorybody> {
  // Data contoh untuk riwayat transaksi[cite: 5].
  final List<Transaction> _transactions = [
    Transaction(
        id: 'TRX001',
        date: DateTime.now().subtract(const Duration(days: 1)),
        amount: 150000,
        status: 'Berhasil'),
    Transaction(
        id: 'TRX002',
        date: DateTime.now().subtract(const Duration(days: 2)),
        amount: 75000,
        status: 'Berhasil'),
    Transaction(
        id: 'TRX003',
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: 250000,
        status: 'Dibatalkan'),
    Transaction(
        id: 'TRX004',
        date: DateTime.now().subtract(const Duration(days: 4)),
        amount: 50000,
        status: 'Berhasil'),
    Transaction(
        id: 'TRX005',
        date: DateTime.now().subtract(const Duration(days: 5)),
        amount: 300000,
        status: 'Menunggu Pembayaran'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          // Memanggil komponen kartu yang sudah dipisah[cite: 5]
          return TransactionCard(transaction: transaction);
        },
      ),
    );
  }
}