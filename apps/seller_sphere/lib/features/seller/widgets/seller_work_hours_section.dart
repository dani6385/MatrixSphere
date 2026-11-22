// lib/features/seller/widgets/seller_work_hours_section.dart

import 'package:flutter/material.dart';
import 'package:matrix_sphere/features/company/widgets/environment_work_hours_card.dart';

/// Bagian pengaturan & tampilan jam kerja khusus untuk lingkungan
/// aplikasi anak **Seller Sphere**.
class SellerWorkHoursSection extends StatelessWidget {
  const SellerWorkHoursSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const EnvironmentWorkHoursCard(
      environmentKey: 'seller_sphere',
      environmentLabel: 'Seller Sphere',
      roleDescription: 'Seller Sphere',
    );
  }
}
