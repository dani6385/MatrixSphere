import 'package:flutter/material.dart';

import '../../models/attendance_rule_model.dart';

class MatrixWorkHoursSummaryCard extends StatelessWidget {
  final AttendanceRuleModel rule;

  const MatrixWorkHoursSummaryCard({super.key, required this.rule});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jam Kerja, Lokasi & Aturan Absensi',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Status Absensi: ${rule.isAttendanceEnabled ? 'Aktif' : 'Nonaktif'} • '
            'Toleransi Terlambat: ${rule.graceMinutes} menit',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Jam Operasional: ${rule.workStart} - ${rule.workEnd}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Titik Koordinat: ${rule.coordinateText}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Batas Radius: ${rule.radiusText}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Wajib GPS/Lokasi: ${rule.requireLocation ? 'Ya' : 'Tidak'} • '
            'Luar Radius: ${rule.allowOutsideRadius ? 'Diizinkan' : 'Ditolak'}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Wajib Kamera/Foto: ${rule.requirePhoto ? 'Ya (${rule.photoTypeLabel})' : 'Tidak'}',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}