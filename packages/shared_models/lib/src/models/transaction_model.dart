
library transaction_model;

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Enum untuk tipe transaksi.
enum TransactionType {
  sale('Penjualan', kSoftTeal),
  refund('Pengembalian Dana', kAlertRed),
  payout('Pencairan Dana', kBlueSecondary);

  final String displayName;
  final Color color;

  const TransactionType(this.displayName, this.color);

  factory TransactionType.fromString(String type) {
    return TransactionType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => TransactionType.sale, // Default value if not found
    );
  }
}

/// Enum untuk status transaksi.
enum TransactionStatus {
  pending('Pending', kWarmOrange),
  completed('Selesai', kSoftTeal),
  failed('Gagal', kAlertRed);

  final String displayName;
  final Color color;

  const TransactionStatus(this.displayName, this.color);

  factory TransactionStatus.fromString(String status) {
    return TransactionStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => TransactionStatus.pending, // Default value if not found
    );
  }
}

/// Model untuk transaksi.
class Transaction {
  final String id; // ID unik dari Firebase (push key)
  final String orderId; // ID pesanan yang terkait (jika ada)
  final String shopId; // ID toko yang terlibat
  final String? buyerId; // ID pembeli (opsional, untuk penjualan)
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime timestamp;
  final String? description; // Deskripsi tambahan

  Transaction({
    required this.id,
    required this.orderId,
    required this.shopId,
    this.buyerId,
    required this.amount,
    required this.type,
    required this.status,
    required this.timestamp,
    this.description,
  });

  /// Factory constructor untuk membuat instance Transaction dari Map (data RTDB).
  factory Transaction.fromMap(Map<String, dynamic> data, String id) {
    DateTime parseTimestamp(dynamic dateValue) {
      if (dateValue is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      } else if (dateValue is String) {
        return DateTime.tryParse(dateValue) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return Transaction(
      id: id,
      orderId: data['orderId'] as String? ?? 'N/A',
      shopId: data['shopId'] as String? ?? 'unknown_shop',
      buyerId: data['buyerId'] as String?,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      type: TransactionType.fromString(data['type'] as String? ?? 'sale'),
      status:
          TransactionStatus.fromString(data['status'] as String? ?? 'pending'),
      timestamp: parseTimestamp(data['timestamp'] ??data['createdAt']),
      description: data['description'] as String?,
    );
  }

  /// Mengonversi instance Transaction menjadi Map untuk disimpan di RTDB.
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'shopId': shopId,
      'buyerId': buyerId,
      'amount': amount,
      'type': type.name,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }
}
