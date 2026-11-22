// lib/screens/attendance/widgets/attendance_day_detail_card.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Kartu detail absensi untuk tanggal yang dipilih pada kalender (`Detail Day`).
/// Dilengkapi tombol lengkapi Check-Out jika pengguna lupa absen pulang pada hari tersebut.
class AttendanceDayDetailCard extends StatelessWidget {
  final DateTime selectedDate;
  final Map<dynamic, dynamic>? dayData;

  /// Callback opsional ketika tombol "Lengkapi Check-Out" ditekan.
  final VoidCallback? onCompleteCheckOut;

  const AttendanceDayDetailCard({
    super.key,
    required this.selectedDate,
    required this.dayData,
    this.onCompleteCheckOut,
  });

  String _formatIndonesianDate(DateTime date) {
    const List<String> dayNames = <String>[
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const List<String> monthNames = <String>[
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final String dayName = dayNames[date.weekday - 1];
    final String monthName = monthNames[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = _formatIndonesianDate(selectedDate);
    final Map<dynamic, dynamic> record = dayData ?? <dynamic, dynamic>{};

    final String? checkInTime = record['checkInTime']?.toString();
    final String? checkOutTime = record['checkOutTime']?.toString();
    final String? note = record['note']?.toString();

    final bool hasCheckIn =
        checkInTime != null && checkInTime.trim().isNotEmpty;
    final bool hasCheckOut =
        checkOutTime != null && checkOutTime.trim().isNotEmpty;
    final bool isMissingCheckOut = hasCheckIn && !hasCheckOut;

    final String statusLabel;
    final Color statusColor;
    final IconData statusIcon;

    if (hasCheckIn && hasCheckOut) {
      statusLabel = 'Hadir Lengkap';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (isMissingCheckOut) {
      statusLabel = 'Belum Absen Pulang (Check-Out)';
      statusColor = Colors.deepOrange;
      statusIcon = Icons.warning_amber_rounded;
    } else {
      statusLabel = 'Tidak Ada Catatan Absensi';
      statusColor = Colors.grey;
      statusIcon = Icons.event_busy;
    }

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: statusColor.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kDarkTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ),
            const Divider(height: 22),
            Row(
              children: [
                Expanded(
                  child: _TimeInfoTile(
                    icon: Icons.login,
                    iconColor: kBrandPrimary,
                    label: 'Jam Masuk (Check-In)',
                    value: hasCheckIn ? checkInTime : '--:--',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimeInfoTile(
                    icon: Icons.logout,
                    iconColor: Colors.deepOrange,
                    label: 'Jam Pulang (Check-Out)',
                    value: hasCheckOut ? checkOutTime : '--:--',
                  ),
                ),
              ],
            ),
            if (note != null && note.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catatan Kerja:',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: kDarkTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      note,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Tombol koreksi jika pengguna belum melakukan Check-Out
            if (isMissingCheckOut && onCompleteCheckOut != null) ...[
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onCompleteCheckOut,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.deepOrange,
                  side: const BorderSide(color: Colors.deepOrange),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                label: const Text(
                  'Lengkapi Check-Out Sekarang',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimeInfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _TimeInfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kDarkTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}