import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

Future<String?> showWorkNoteSheet({
  required BuildContext context,
  required String initialNote,
  required bool isCheckOutMode,
  double bottomBarClearance = 96.0,
}) async {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final TextEditingController draftController =
      TextEditingController(text: initialNote);

  final String? result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (BuildContext sheetContext) {
      // Mengambil tinggi keyboard (jika terbuka) dan padding sistem bagian bawah
      final double keyboardInset = MediaQuery.of(sheetContext).viewInsets.bottom;
      final double systemBottom = MediaQuery.of(sheetContext).padding.bottom;

      // Memastikan jarak bawah selalu lebih tinggi dari BottomNavBar
      final double effectiveBottomPadding =
          (keyboardInset > bottomBarClearance ? keyboardInset : bottomBarClearance) +
              systemBottom +
              12.0;

      return SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, effectiveBottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Garis pegangan kecil di atas sheet agar terlihat jelas
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
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
                controller: draftController,
                autofocus: true,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText:
                      'Contoh: Cek panel pompa, instalasi jaringan, atau laporan harian...',
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop(draftController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBrandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Catatan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  draftController.dispose();
  return result;
}