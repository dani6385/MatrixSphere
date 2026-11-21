// lib/features/company/company_profile.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/features/company/widgets/environment_work_hours_card.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';

import 'models/company_profile_model.dart';
import 'widgets/work_hours_form_card.dart';

/// Halaman Profil Perusahaan (`CompanyProfile`) untuk Matrix Sphere & Seller Sphere.
class CompanyProfile extends StatelessWidget {
  const CompanyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference companyRef = FirebaseDatabase.instance.ref(
      'company_profile',
    );
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Perusahaan'),
        actions: [
          IconButton(
            tooltip: 'Edit Profil',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => AppNavigation.openEditProfile(context),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: companyRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<dynamic, dynamic>? rawData;
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            rawData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          }

          final CompanyProfileModel company = CompanyProfileModel.fromMap(
            rawData,
          );

          final String matrixStart =
              rawData?['matrixSphereWorkStart']?.toString() ?? '08:00';
          final String matrixEnd =
              rawData?['matrixSphereWorkEnd']?.toString() ?? '17:00';
          final String sellerStart =
              rawData?['sellerSphereWorkStart']?.toString() ?? '08:00';
          final String sellerEnd =
              rawData?['sellerSphereWorkEnd']?.toString() ?? '17:00';
          final bool isAttendanceEnabled =
              rawData?['isAttendanceEnabled'] is bool
              ? rawData!['isAttendanceEnabled'] as bool
              : true;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
            children: [
              // Kartu Avatar & Identitas Utama Perusahaan[cite: 6]
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: company.hasLogo
                          ? NetworkImage(company.logoUrl!)
                          : null,
                      child: !company.hasLogo
                          ? Icon(
                              Icons.apartment,
                              size: 44,
                              color: colorScheme.primary,
                            )
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      company.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      company.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Formulir TextField Jam Mulai & Jam Selesai (Matrix Sphere & Seller Sphere)
              WorkHoursFormCard(
                initialMatrixStart: matrixStart,
                initialMatrixEnd: matrixEnd,
                initialSellerStart: sellerStart,
                initialSellerEnd: sellerEnd,
                initialAttendanceEnabled: isAttendanceEnabled,
              ),
              const EnvironmentWorkHoursCard(
                environmentKey: 'matrix_sphere',
                environmentLabel: 'Matrix Sphere',
                roleDescription:
                    'Jam kerja pekerja di lingkungan Matrix Sphere',
              ),
              const SizedBox(height: 24),
              // Detail Informasi Perusahaan[cite: 6]
              _CompanyInfoTile(
                icon: Icons.phone_outlined,
                label: 'Telepon',
                value: company.phone ?? 'Belum diatur',
              ),
              _CompanyInfoTile(
                icon: Icons.location_on_outlined,
                label: 'Alamat',
                value: company.address ?? 'Belum diatur',
              ),
              _CompanyInfoTile(
                icon: Icons.info_outline,
                label: 'Deskripsi',
                value: company.description ?? 'Belum ada deskripsi perusahaan.',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CompanyInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CompanyInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(value),
        ),
      ),
    );
  }
}
