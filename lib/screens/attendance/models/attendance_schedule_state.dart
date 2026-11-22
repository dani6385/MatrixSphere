// lib/screens/attendance/models/attendance_schedule_state.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceScheduleEvaluator {
  final String workStartTime;
  final String workEndTime;
  final DateTime now;

  final DateTime? startDt;
  final DateTime? endDt;
  final DateTime? checkInOpenAt;
  final String checkInOpenText;
  final bool isWithinCheckInWindow;

  final DateTime? checkOutOpenAt;
  final DateTime? checkOutCloseAt;
  final String checkOutCloseText;
  final bool isWithinCheckOutWindow;

  AttendanceScheduleEvaluator._({
    required this.workStartTime,
    required this.workEndTime,
    required this.now,
    required this.startDt,
    required this.endDt,
    required this.checkInOpenAt,
    required this.checkInOpenText,
    required this.isWithinCheckInWindow,
    required this.checkOutOpenAt,
    required this.checkOutCloseAt,
    required this.checkOutCloseText,
    required this.isWithinCheckOutWindow,
  });

  factory AttendanceScheduleEvaluator.fromSchedule({
    required String workStartTime,
    required String workEndTime,
    required DateTime now,
  }) {
    final DateTime? startDt = parseTodayTime(workStartTime, now);
    final DateTime? endDt = parseTodayTime(workEndTime, now);

    // Check-In aktif mulai 1 jam sebelum jam mulai kerja (misal 08:00 -> 07:00)
    final DateTime? checkInOpenAt =
        startDt?.subtract(const Duration(minutes: 60));
    final String checkInOpenText =
        checkInOpenAt != null ? formatTime(checkInOpenAt) : workStartTime;
    final bool isWithinCheckInWindow =
        checkInOpenAt != null && !now.isBefore(checkInOpenAt);

    // Check-Out aktif TEPAT saat jam selesai kerja hingga +1 jam (misal 17:00 - 18:00)
    final DateTime? checkOutOpenAt = endDt;
    final DateTime? checkOutCloseAt = endDt?.add(const Duration(minutes: 60));
    final String checkOutCloseText =
        checkOutCloseAt != null ? formatTime(checkOutCloseAt) : workEndTime;
    final bool isWithinCheckOutWindow =
        checkOutOpenAt != null &&
        checkOutCloseAt != null &&
        !now.isBefore(checkOutOpenAt) &&
        !now.isAfter(checkOutCloseAt);

    return AttendanceScheduleEvaluator._(
      workStartTime: workStartTime,
      workEndTime: workEndTime,
      now: now,
      startDt: startDt,
      endDt: endDt,
      checkInOpenAt: checkInOpenAt,
      checkInOpenText: checkInOpenText,
      isWithinCheckInWindow: isWithinCheckInWindow,
      checkOutOpenAt: checkOutOpenAt,
      checkOutCloseAt: checkOutCloseAt,
      checkOutCloseText: checkOutCloseText,
      isWithinCheckOutWindow: isWithinCheckOutWindow,
    );
  }

  int calculateLateMinutes(DateTime checkInTime) {
    if (startDt != null && checkInTime.isAfter(startDt!)) {
      return checkInTime.difference(startDt!).inMinutes;
    }
    return 0;
  }

  static String getDateKey(DateTime dt) {
    final String yyyy = dt.year.toString().padLeft(4, '0');
    final String mm = dt.month.toString().padLeft(2, '0');
    final String dd = dt.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  static String formatTime(DateTime dt) {
    final String hh = dt.hour.toString().padLeft(2, '0');
    final String mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  static DateTime? parseTodayTime(String hhmm, DateTime reference) {
    final List<String> parts = hhmm.trim().split(':');
    if (parts.length != 2) return null;
    final int? hour = int.tryParse(parts[0]);
    final int? minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return DateTime(
      reference.year,
      reference.month,
      reference.day,
      hour,
      minute,
    );
  }

  static String formatLateDuration(int totalMinutes) {
    if (totalMinutes < 60) {
      return '$totalMinutes menit';
    }
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    if (minutes == 0) {
      return '$hours jam';
    }
    return '$hours jam $minutes menit';
  }
}

class AttendanceStatusDisplay {
  final String statusTitle;
  final String statusSubtitle;
  final Color statusColor;
  final IconData statusIcon;
  final String buttonLabel;
  final IconData buttonIcon;
  final Color buttonColor;
  final bool isButtonDisabled;

  const AttendanceStatusDisplay({
    required this.statusTitle,
    required this.statusSubtitle,
    required this.statusColor,
    required this.statusIcon,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.buttonColor,
    required this.isButtonDisabled,
  });

  factory AttendanceStatusDisplay.resolve({
    required AttendanceScheduleEvaluator schedule,
    required bool isCompleted,
    required bool isCheckOutStep,
    required bool isSaving,
    required String? checkInTime,
    required String? recordedStatus,
    required bool isLateToday,
    required int lateMinutesToday,
  }) {
    if (isCompleted) {
      return AttendanceStatusDisplay(
        statusTitle: 'Absensi Hari Ini ${recordedStatus ?? "Selesai"}',
        statusSubtitle:
            'Jam kerja ${schedule.workStartTime} - ${schedule.workEndTime}. Reset otomatis pukul 00:00.',
        statusColor: Colors.green,
        statusIcon: Icons.check_circle,
        buttonLabel: 'Sudah Absen Pulang',
        buttonIcon: Icons.verified,
        buttonColor: Colors.green,
        isButtonDisabled: true,
      );
    }

    if (isCheckOutStep) {
      final String lateInfo = (isLateToday && lateMinutesToday > 0)
          ? ' (Terlambat ${AttendanceScheduleEvaluator.formatLateDuration(lateMinutesToday)})'
          : '';
      if (!schedule.isWithinCheckOutWindow) {
        return AttendanceStatusDisplay(
          statusTitle: 'Belum Waktunya Absen Pulang',
          statusSubtitle:
              'Masuk pukul $checkInTime$lateInfo. Tombol Check-Out aktif pukul ${schedule.workEndTime} - ${schedule.checkOutCloseText}.',
          statusColor: Colors.grey.shade700,
          statusIcon: Icons.schedule,
          buttonLabel: 'Check-Out Aktif Pukul ${schedule.workEndTime}',
          buttonIcon: Icons.lock_clock,
          buttonColor: Colors.grey,
          isButtonDisabled: true,
        );
      }

      return AttendanceStatusDisplay(
        statusTitle: 'Waktunya Absen Pulang (Check-Out)',
        statusSubtitle:
            'Masuk pukul $checkInTime$lateInfo. Absen pulang dibuka pukul ${schedule.workEndTime} - ${schedule.checkOutCloseText}.',
        statusColor: Colors.deepOrange,
        statusIcon: Icons.logout,
        buttonLabel: 'Check-Out Sekarang',
        buttonIcon: Icons.logout,
        buttonColor: Colors.deepOrange,
        isButtonDisabled: isSaving,
      );
    }

    if (!schedule.isWithinCheckInWindow) {
      return AttendanceStatusDisplay(
        statusTitle: 'Absen Masuk Belum Dibuka',
        statusSubtitle:
            'Jam kerja ${schedule.workStartTime} - ${schedule.workEndTime}. Check-In dibuka mulai pukul ${schedule.checkInOpenText}.',
        statusColor: Colors.grey.shade700,
        statusIcon: Icons.schedule,
        buttonLabel: 'Check-In Dibuka Pukul ${schedule.checkInOpenText}',
        buttonIcon: Icons.lock_clock,
        buttonColor: Colors.grey,
        isButtonDisabled: true,
      );
    }

    return AttendanceStatusDisplay(
      statusTitle: 'Belum Absen Masuk Hari Ini',
      statusSubtitle:
          'Jam kerja ${schedule.workStartTime} - ${schedule.workEndTime}. Check-In dibuka sejak pukul ${schedule.checkInOpenText}.',
      statusColor: kBrandPrimary,
      statusIcon: Icons.login,
      buttonLabel: 'Check-In Sekarang',
      buttonIcon: Icons.login,
      buttonColor: kBrandPrimary,
      isButtonDisabled: isSaving,
    );
  }
}