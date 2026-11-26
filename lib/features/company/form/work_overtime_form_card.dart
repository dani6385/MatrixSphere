import 'package:flutter/material.dart';

import '../models/edit_company_form_state.dart';

class WorkAndOvertimeCard extends StatelessWidget {
  final CompanyFormState? formState;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool canEdit;
  final bool isSaving;
  final bool isOvertimeActive;
  final bool isExpired;
  final String effectiveCheckoutTime;
  final VoidCallback? onSave;
  final VoidCallback? onClear;
  final ValueChanged<bool>? onOvertimeChanged;
  final bool showRegularWorkSection;
  final bool showOvertimeQuickCard;

  const WorkAndOvertimeCard({
    super.key,
    this.formState,
    this.controller,
    this.focusNode,
    bool? canEdit,
    bool? isAdmin,
    this.isSaving = false,
    this.isOvertimeActive = false,
    this.isExpired = false,
    this.effectiveCheckoutTime = '16:00',
    this.onSave,
    this.onClear,
    this.onOvertimeChanged,
    bool? showRegularWorkSection,
    bool? showOvertimeQuickCard,
  })  : canEdit = canEdit ?? isAdmin ?? true,
        showRegularWorkSection = showRegularWorkSection ?? (formState != null),
        showOvertimeQuickCard =
            showOvertimeQuickCard ?? (controller != null && focusNode != null);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final CompanyFormState? state = formState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRegularWorkSection && state != null) ...[
          Text(
            'Jam Kerja Reguler (Senin - Jumat)',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: state.matrixStartController,
                  readOnly: !canEdit,
                  decoration:
                      const InputDecoration(labelText: 'Jam Mulai (HH:mm)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: state.matrixEndController,
                  readOnly: !canEdit,
                  decoration:
                      const InputDecoration(labelText: 'Jam Selesai (HH:mm)'),
                ),
              ),
            ],
          ),
          if (state.isOvertimeRequired) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: state.decreeNoteController,
              readOnly: !canEdit,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Keterangan Dekrit Lembur',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: state.overtimeScheduleTextController,
              readOnly: !canEdit,
              decoration: const InputDecoration(
                labelText: 'Keterangan / Batas Waktu Lembur',
                hintText: 'Contoh: Lembur sampai jam 7 malam',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: state.weekdayOvertimeEndController,
              readOnly: !canEdit,
              decoration: const InputDecoration(
                labelText: 'Batas Akhir Lembur Senin - Jumat (HH:mm)',
                hintText: 'Contoh: 21:00',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: state.saturdayStartController,
                    readOnly: !canEdit,
                    decoration:
                        const InputDecoration(labelText: 'Mulai Sabtu (HH:mm)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: state.saturdayEndController,
                    readOnly: !canEdit,
                    decoration: const InputDecoration(
                      labelText: 'Selesai Sabtu (HH:mm)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: state.sundayStartController,
                    readOnly: !canEdit,
                    decoration:
                        const InputDecoration(labelText: 'Mulai Minggu (HH:mm)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: state.sundayEndController,
                    readOnly: !canEdit,
                    decoration: const InputDecoration(
                      labelText: 'Selesai Minggu (HH:mm)',
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (showOvertimeQuickCard) const SizedBox(height: 16),
        ],
        if (showOvertimeQuickCard && controller != null && focusNode != null)
          Card(
            elevation: 0,
            color: isOvertimeActive
                ? colorScheme.primaryContainer.withValues(alpha: 0.25)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isOvertimeActive
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 20,
                        color: isOvertimeActive
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Overtime Work (Lembur)',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isOvertimeActive
                              ? Colors.green.withValues(alpha: 0.15)
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isOvertimeActive
                              ? 'LEMBUR AKTIF'
                              : 'NONAKTIF (PULANG 16:00)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isOvertimeActive
                                ? Colors.green.shade800
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jam Pulang Efektif: $effectiveCheckoutTime'
                    '${isExpired ? ' (Batas jam lembur sebelumnya sudah terlewati)' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isOvertimeActive
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    enabled: canEdit && !isSaving,
                    readOnly: !canEdit,
                    decoration: InputDecoration(
                      labelText: 'Jadwal / Batas Lembur (Overtime Work)',
                      hintText: 'Contoh: Lembur sampai jam 19:00',
                      helperText: canEdit
                          ? 'Hanya Admin & Manager Kepegawaian. Kosongkan atau lewat jam lembur -> pulang 16:00.'
                          : 'Hanya dapat diisi oleh Manager Kepegawaian dan Admin.',
                      helperMaxLines: 2,
                      border: const OutlineInputBorder(),
                      suffixIcon: (canEdit && controller!.text.isNotEmpty)
                          ? IconButton(
                              tooltip: 'Kosongkan (Pulang 16:00)',
                              icon: const Icon(Icons.clear),
                              onPressed: isSaving ? null : onClear,
                            )
                          : null,
                    ),
                  ),
                  if (canEdit) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: isSaving ? null : onClear,
                          child: const Text('Reset Pulang 16:00'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: isSaving ? null : onSave,
                          icon: isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined, size: 18),
                          label:
                              Text(isSaving ? 'Menyimpan...' : 'Simpan Lembur'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

typedef WorkOvertimeFormCard = WorkAndOvertimeCard;
typedef WorkAndOvertimeForm = WorkAndOvertimeCard;