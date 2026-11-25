import 'package:flutter/material.dart';
import '../models/edit_company_form_state.dart';

class WorkAndOvertimeForm extends StatelessWidget {
  final EditCompanyFormState formState;
  final bool isAdmin;
  final ValueChanged<bool> onOvertimeChanged;

  const WorkAndOvertimeForm({
    super.key,
    required this.formState,
    required this.isAdmin,
    required this.onOvertimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jam Kerja Reguler (Senin - Jumat)',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: formState.matrixStartController,
                readOnly: !isAdmin,
                decoration: const InputDecoration(labelText: 'Jam Mulai (HH:mm)'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: formState.matrixEndController,
                readOnly: !isAdmin,
                decoration:
                    const InputDecoration(labelText: 'Jam Selesai (HH:mm)'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: formState.graceMinutesController,
          readOnly: !isAdmin,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Toleransi Keterlambatan (menit)',
            hintText: 'Contoh: 15',
          ),
          validator: (v) {
            final int? val = int.tryParse(v?.trim() ?? '');
            if (val == null || val < 0) {
              return 'Masukkan angka >= 0';
            }
            return null;
          },
        ),
        if (formState.isOvertimeRequired) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: formState.decreeNoteController,
            readOnly: !isAdmin,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Keterangan Dekrit Lembur',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: formState.overtimeScheduleTextController,
            readOnly: !isAdmin,
            decoration: const InputDecoration(
              labelText: 'Keterangan / Batas Waktu Lembur',
              hintText: 'Contoh: Lembur sampai jam 7 malam',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: formState.weekdayOvertimeEndController,
            readOnly: !isAdmin,
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
                  controller: formState.saturdayStartController,
                  readOnly: !isAdmin,
                  decoration:
                      const InputDecoration(labelText: 'Mulai Sabtu (HH:mm)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: formState.saturdayEndController,
                  readOnly: !isAdmin,
                  decoration:
                      const InputDecoration(labelText: 'Selesai Sabtu (HH:mm)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: formState.sundayStartController,
                  readOnly: !isAdmin,
                  decoration:
                      const InputDecoration(labelText: 'Mulai Minggu (HH:mm)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: formState.sundayEndController,
                  readOnly: !isAdmin,
                  decoration:
                      const InputDecoration(labelText: 'Selesai Minggu (HH:mm)'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}