import 'package:flutter/material.dart';
import '../models/edit_company_form_state.dart';

class LocationRadiusForm extends StatelessWidget {
  final CompanyFormState formState;
  final bool isAdmin;

  const LocationRadiusForm({
    super.key,
    required this.formState,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lokasi & Radius Absensi (GPS & Kamera Wajib Aktif)',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: formState.latitudeController,
                readOnly: !isAdmin,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Latitude (contoh: -6.200000)',
                ),
                validator: (v) {
                  final String raw = v?.trim() ?? '';
                  if (raw.isEmpty) return 'Latitude wajib diisi';
                  final double? parsed = double.tryParse(raw);
                  if (parsed == null || parsed < -90 || parsed > 90) {
                    return 'Latitude tidak valid (-90 s.d. 90)';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: formState.longitudeController,
                readOnly: !isAdmin,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Longitude (contoh: 106.816666)',
                ),
                validator: (v) {
                  final String raw = v?.trim() ?? '';
                  if (raw.isEmpty) return 'Longitude wajib diisi';
                  final double? parsed = double.tryParse(raw);
                  if (parsed == null || parsed < -180 || parsed > 180) {
                    return 'Longitude tidak valid (-180 s.d. 180)';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: formState.radiusMetersController,
          readOnly: !isAdmin,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Radius Absensi (meter)',
            hintText: 'Contoh: 100',
          ),
          validator: (v) {
            final String raw = v?.trim() ?? '';
            if (raw.isEmpty) return 'Radius wajib diisi';
            final double? parsed = double.tryParse(raw);
            if (parsed == null || parsed <= 0) {
              return 'Radius harus lebih dari 0 meter';
            }
            return null;
          },
        ),
      ],
    );
  }
}