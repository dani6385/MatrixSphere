import 'package:flutter/material.dart';

class AppErrorModel {
  final String id;
  final String appName;
  final String appVersion;
  final String errorMessage;
  final String stackTrace;
  final String contextInfo;
  final String deviceInfo;
  final String userEmail;
  final String timestamp;
  final String status;

  const AppErrorModel({
    required this.id,
    required this.appName,
    required this.appVersion,
    required this.errorMessage,
    required this.stackTrace,
    required this.contextInfo,
    required this.deviceInfo,
    required this.userEmail,
    required this.timestamp,
    required this.status,
  });

  bool get isResolved => status == 'resolved';

  factory AppErrorModel.fromMap(String key, Map<dynamic, dynamic> map) {
    return AppErrorModel(
      id: map['id']?.toString() ?? key,
      appName: map['appName']?.toString() ?? 'unknown',
      appVersion: map['appVersion']?.toString() ?? '-',
      errorMessage: map['errorMessage']?.toString() ?? 'Error tidak diketahui',
      stackTrace: map['stackTrace']?.toString() ?? 'Tidak ada detail stack trace',
      contextInfo: map['contextInfo']?.toString() ?? '-',
      deviceInfo: map['deviceInfo']?.toString() ?? '-',
      userEmail: map['userEmail']?.toString() ?? '-',
      timestamp: map['timestamp']?.toString() ?? '',
      status: map['status']?.toString() ?? 'open',
    );
  }

  /// Memberikan warna badge pembeda untuk setiap aplikasi di monorepo
  Color get badgeColor {
    switch (appName) {
      case 'admin_mikrotik':
        return Colors.indigo;
      case 'client_connectivity':
        return Colors.teal;
      case 'seller_sphere':
        return Colors.deepOrange;
      case 'shop_sphere':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}