// lib/screens/attendance/widgets/work_note_sheet.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Bottom sheet untuk mengisi catatan rencana kerja (Check-In)
/// atau penyelesaian kerja (Check-Out)[cite: 12].
Future<void> showWorkNoteSheet({
  required BuildContext context,
  required TextEditingController controller,
  required bool isCheckOutMode,
}) async {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (BuildContext sheetContext) {
      final double bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isCheckOutMode
                  ? 'Catatan Penyelesaian Kerja (Check-Out)'
                  : 'Catatan Rencana Kerja (Check-In)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText:
                    'Contoh: Cek panel pompa, instalasi jaringan, atau laporan harian...',
                filled: true,
                fillColor:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(sheetContext).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBrandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simpan Catatan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    },
  );
}