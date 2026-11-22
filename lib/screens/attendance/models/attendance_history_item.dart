// lib/screens/Attendance/models/attendance_history_item.dart

import 'package:flutter/material.dart';

class AttendanceHistoryItem {
  final String dateKey;
  final String checkInTime;
  final String checkOutTime;
  final String status;
  final String statusCode;
  final bool isLate;
  final int lateMinutes;
  final bool isOvertime;
  final bool forgotCheckOut;
  final String note;
  final int? checkInDistanceMeters;
  final int? checkOutDistanceMeters;

  const AttendanceHistoryItem({
    required this.dateKey,
    required this.checkInTime,
    required this.checkOutTime,
    required this.status,
    required this.statusCode,
    required this.isLate,
    required this.lateMinutes,
    required this.isOvertime,
    required this.forgotCheckOut,
    required this.note,
    this.checkInDistanceMeters,
    this.checkOutDistanceMeters,
  });

  static final RegExp _dateKeyPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  static bool isDateKey(String key) => _dateKeyPattern.hasMatch(key);

  factory AttendanceHistoryItem.fromMap({
    required String dateKey,
    required Map<dynamic, dynamic> map,
  }) {
    int? parseDistance(dynamic locationVal) {
      if (locationVal is Map<dynamic, dynamic>) {
        final dynamic dist = locationVal['distanceToOfficeMeters'];
        if (dist is num) return dist.round();
        return int.tryParse(dist?.toString() ?? '');
      }
      return null;
    }

    final String rawCheckIn = map['checkInTime']?.toString().trim() ?? '';
    final String rawCheckOut = map['checkOutTime']?.toString().trim() ?? '';

    return AttendanceHistoryItem(
      dateKey: dateKey,
      checkInTime: rawCheckIn.isNotEmpty ? rawCheckIn : '--:--',
      checkOutTime: rawCheckOut.isNotEmpty ? rawCheckOut : '--:--',
      status: map['status']?.toString().trim() ?? 'Tercatat',
      statusCode: map['statusCode']?.toString().trim() ?? '',
      isLate: map['isLate'] == true,
      lateMinutes: int.tryParse(map['lateMinutes']?.toString() ?? '0') ?? 0,
      isOvertime: map['isOvertime'] == true,
      forgotCheckOut: map['forgotCheckOut'] == true,
      note: map['note']?.toString().trim() ?? '',
      checkInDistanceMeters: parseDistance(map['checkInLocation']),
      checkOutDistanceMeters: parseDistance(map['checkOutLocation']),
    );
  }

  Color get statusColor {
    if (forgotCheckOut || statusCode == 'forgot_checkout_reset') {
      return Colors.red.shade700;
    }
    if (isOvertime) {
      return Colors.indigo;
    }
    if (isLate) {
      return Colors.orange.shade800;
    }
    if (statusCode == 'completed') {
      return Colors.green.shade700;
    }
    return Colors.blue.shade700;
  }

  IconData get statusIcon {
    if (forgotCheckOut || statusCode == 'forgot_checkout_reset') {
      return Icons.error_outline;
    }
    if (isOvertime) {
      return Icons.more_time;
    }
    if (isLate) {
      return Icons.warning_amber_rounded;
    }
    if (statusCode == 'completed') {
      return Icons.check_circle_outline;
    }
    return Icons.login;
  }

  String get displayStatusLabel {
    if (isLate && lateMinutes > 0 && !status.contains('Terlambat')) {
      return '$status (Terlambat $lateMinutes mnt)';
    }
    return status;
  }
}