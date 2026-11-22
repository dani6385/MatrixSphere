// lib/screens/attendance/widgets/attendance_dialogs.dart

import 'package:flutter/material.dart';

class AttendanceDialogs {
  AttendanceDialogs._();

  static Future<bool?> showOvertimeConfirmation(
    BuildContext context, {
    required String workEndTime,
    required String closeTimeText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Absen Pulang'),
        content: Text(
          'Absen pulang dibuka pukul $workEndTime - $closeTimeText.\nApakah Anda melakukan lembur hari ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Tidak Lembur'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ya, Lembur'),
          ),
        ],
      ),
    );
  }

  static Future<void> showLateWarning(
    BuildContext context, {
    required String lateDurationText,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.amber,
          size: 36,
        ),
        title: const Text('Peringatan Keterlambatan'),
        content: Text(
          'Anda terlambat sekitar $lateDurationText dari jam masuk.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}