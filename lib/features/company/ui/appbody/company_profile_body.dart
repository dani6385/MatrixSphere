import 'package:flutter/material.dart';

import '../../config/company_config.dart';
import '../../logic/company_profile_logic.dart';
import '../../models/attendance_rule_model.dart';
import '../../models/company_profile_model.dart';
import '../../services/company_service.dart';
import '../widgets/company_header_widget.dart';
import '../widgets/company_info_tile.dart';
import '../widgets/matrix_work_hours_summary_card.dart';

class CompanyProfileBody extends StatelessWidget {
  final CompanyProfileLogic logic;

  const CompanyProfileBody({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompanyProfileBundle>(
      stream: logic.companyStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final CompanyProfileBundle bundle =
            snapshot.data ??
            CompanyProfileBundle(
              company: CompanyProfileModel.fromMap(null),
              attendanceRule: AttendanceRuleModel.fromMap(null),
            );

        final CompanyProfileModel company = bundle.company;
        final AttendanceRuleModel rule = bundle.attendanceRule;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
          children: [
            CompanyHeaderWidget(company: company, rule: rule),
            const SizedBox(height: 24),
            const CompanySectionTitle(title: 'Aturan & Operasional'),
            MatrixWorkHoursSummaryCard(rule: rule),
            const SizedBox(height: 22),
            const CompanySectionTitle(title: 'Informasi Perusahaan & Kontak'),
            CompanyInfoTile(
              icon: Icons.phone_outlined,
              label: 'Telepon',
              value: company.phone ?? CompanyConfig.unconfiguredText,
            ),
            CompanyInfoTile(
              icon: Icons.location_on_outlined,
              label: 'Alamat',
              value: company.address ?? CompanyConfig.unconfiguredText,
            ),
            CompanyInfoTile(
              icon: Icons.my_location_outlined,
              label: 'Koordinat & Radius Absensi',
              value:
                  'Titik: ${rule.coordinateText} • Radius: ${rule.radiusText}',
            ),
            CompanyInfoTile(
              icon: Icons.camera_alt_outlined,
              label: 'Kebutuhan Lokasi & Kamera',
              value:
                  'Lokasi: ${rule.requireLocation ? 'Wajib' : 'Opsional'} • '
                  'Kamera: ${rule.requirePhoto ? 'Wajib (${rule.photoTypeLabel})' : 'Opsional'} • '
                  'Luar Radius: ${rule.allowOutsideRadius ? 'Diizinkan (Review)' : 'Ditolak'} • '
                  'Toleransi: ${rule.graceMinutes} mnt',
            ),
            CompanyInfoTile(
              icon: Icons.info_outline,
              label: 'Deskripsi',
              value: company.description ?? CompanyConfig.emptyDescriptionText,
            ),
          ],
        );
      },
    );
  }
}