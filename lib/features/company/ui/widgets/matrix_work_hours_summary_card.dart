import 'package:flutter/material.dart';

import '../../models/attendance_rule_model.dart';

class MatrixWorkHoursSummaryCard extends StatelessWidget {
  final AttendanceRuleModel rule;

  const MatrixWorkHoursSummaryCard({super.key, required this.rule});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jam Kerja, Lokasi & Aturan Absensi',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status Absensi: ${rule.isAttendanceEnabled ? 'Aktif' : 'Nonaktif'} • '
              'Toleransi Terlambat: ${rule.graceMinutes} menit',
            ),
            const SizedBox(height: 4),
            Text('Jam Operasional: ${rule.workStart} - ${rule.workEnd}'),
            const SizedBox(height: 4),
            Text('Titik Koordinat: ${rule.coordinateText}'),
            const SizedBox(height: 4),
            Text('Batas Radius: ${rule.radiusText}'),
            const SizedBox(height: 4),
            Text(
              'Wajib GPS/Lokasi: ${rule.requireLocation ? 'Ya' : 'Tidak'} • '
              'Luar Radius: ${rule.allowOutsideRadius ? 'Diizinkan' : 'Ditolak'}',
            ),
            const SizedBox(height: 4),
            Text(
              'Wajib Kamera/Foto: ${rule.requirePhoto ? 'Ya (${rule.photoTypeLabel})' : 'Tidak'}',
            ),
          ],
        ),
      ),
    );
  }
}