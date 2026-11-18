
import 'package:flutter/material.dart';
import 'package:matrix_sphere/features/company/models/company_profile_model.dart';

class VisionMision extends StatelessWidget {
  final CompanyProfileModel company;

  const VisionMision({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Visi Perusahaan', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(company.vision, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
            const Divider(height: 24),
            const Text('Misi Perusahaan', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(company.mission, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
          ],
        ),
      ),
    );
  }
}