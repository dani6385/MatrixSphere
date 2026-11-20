// lib/screens/attendance/widgets/work_note_bar.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Bar ringkas untuk membuka modal catatan kerja di atas panel aksi absensi[cite: 12].
class WorkNoteBar extends StatelessWidget {
  final String noteText;
  final bool enabled;
  final VoidCallback onTap;

  const WorkNoteBar({
    super.key,
    required this.noteText,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: kBrandPrimary.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.edit_note, size: 20, color: kBrandPrimary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                noteText.isEmpty
                    ? 'Tambah catatan kerja (opsional)...'
                    : 'Catatan: $noteText',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: noteText.isEmpty
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                  fontWeight:
                      noteText.isEmpty ? FontWeight.normal : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}