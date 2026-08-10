// lib/services/transaction_export_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Import model Transaction milikmu
// import '../models/transaction.dart';

class TransactionExportService {
  // Fungsi untuk mengekspor data ke CSV
  static Future<void> exportToCsv(BuildContext context, List<dynamic> transactions) async {
    if (transactions.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data untuk diekspor')),
      );
      return;
    }

    List<List<dynamic>> rows = [];
    // Header CSV
    rows.add(['ID', 'Tanggal', 'Tipe', 'Jumlah', 'Deskripsi']);
    
    // Memasukkan data transaksi
    for (var transaction in transactions) {
      rows.add([
        transaction.id,
        transaction.date.toIso8601String(),
        transaction.type,
        transaction.amount,
        transaction.description,
      ]);
    }

    String csv = const ListToCsvConverter()().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/transaksi.csv';
    final file = File(path);
    await file.writeAsString(csv);
    
    // Menggunakan openFile untuk keamanan
    await OpenFile.open(path);
  }

  // Fungsi untuk mengekspor data ke PDF
  static Future<void> exportToPdf(BuildContext context, List<dynamic> transactions) async {
    if (transactions.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data untuk diekspor')),
      );
      return;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Laporan Transaksi')),
          pw.Table.fromTextArray(
            headers: ['Tanggal', 'Tipe', 'Deskripsi', 'Jumlah'],
            data: transactions.map((t) => [
              DateFormat('d MMM yyyy').format(t.date),
              t.type,
              t.description,
              'Rp ${t.amount.toStringAsFixed(0)}',
            ]).toList(),
            headerStyle: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/transaksi.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(path);
  }
}