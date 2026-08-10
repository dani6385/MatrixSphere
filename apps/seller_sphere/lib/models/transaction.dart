// lib/screens/transaction_screen.dart
import 'package:flutter/material.dart';
import '../services/transaction_export_service.dart'; // Import service ekspor

// Asumsikan model Transaction ada di sini atau diimport dari file model
class Transaction {
  final String id;
  final DateTime date;
  final String type;
  final double amount;
  final String description;

  Transaction({
    required this.id,
    required this.date,
    required this.type,
    required this.amount,
    required this.description,
  });
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final List<Transaction> _allTransactions = [
    // ... data transaksi Anda
  ];

  late List<Transaction> _filteredTransactions;

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _allTransactions;
  }

  void _applyFilter(DateTime? startDate, DateTime? endDate, String? type) {
    setState(() {
      _filteredTransactions = _allTransactions.where((t) {
        final isAfterStartDate = startDate == null || t.date.isAfter(startDate.subtract(const Duration(days: 1)));
        final isBeforeEndDate = endDate == null || t.date.isBefore(endDate.add(const Duration(days: 1)));
        final isTypeMatch = type == null || t.type == type;
        return isAfterStartDate && isBeforeEndDate && isTypeMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Logika pemanggilan bottom sheet filter di sini
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pdf') {
                TransactionExportService.exportToPdf(context, _filteredTransactions);
              } else if (value == 'csv') {
                TransactionExportService.exportToCsv(context, _filteredTransactions);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'pdf',
                child: Text('Ekspor ke PDF'),
              ),
              const PopupMenuItem<String>(
                value: 'csv',
                child: Text('Ekspor ke CSV'),
              ),
            ],
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = _filteredTransactions[index];
          return ListTile(
            title: Text(transaction.description),
            subtitle: Text(transaction.type),
            trailing: Text('Rp ${transaction.amount}'),
          );
        },
      ),
    );
  }
}