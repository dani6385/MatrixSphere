import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'models/company_profile_model.dart';

/// Halaman Profil Perusahaan (`CompanyProfile`) khusus tampilan & navigasi edit.
class CompanyProfile extends StatelessWidget {
  const CompanyProfile({super.key});

  static const String _permanentAdminUid = 'mjS1Y9Ll3JRQCMGSTK2oIBVIHT22';

  Future<bool> _checkIsMatrixAdmin(User? user) async {
    if (user == null) return false;
    if (user.uid == _permanentAdminUid) return true;

    final IdTokenResult tokenResult = await user.getIdTokenResult(true);
    final Map<String, dynamic>? claims = tokenResult.claims;
    return claims?['admin'] == true || claims?['isAdmin'] == true;
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim());
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference companyRef = FirebaseDatabase.instance.ref(
      'company_profile',
    );
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return FutureBuilder<bool>(
      future: _checkIsMatrixAdmin(currentUser),
      builder: (context, adminSnapshot) {
        final bool isAdmin = adminSnapshot.data ?? false;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Perusahaan'),
            actions: [
              if (isAdmin)
                IconButton(
                  tooltip: 'Edit Profil',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => AppNavigation.openEditCompanyProfile(context),
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
                rawData =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              }

              final CompanyProfileModel company = CompanyProfileModel.fromMap(
                rawData,
              );

              final String matrixStart =
                  rawData?['matrixSphereWorkStart']?.toString() ?? '08:00';
              final String matrixEnd =
                  rawData?['matrixSphereWorkEnd']?.toString() ?? '17:00';
              final bool isAttendanceEnabled =
                  rawData?['isAttendanceEnabled'] is bool
                  ? rawData!['isAttendanceEnabled'] as bool
                  : true;

              // Baca koordinat titik pusat & radius absensi dari company_profile
              final double? officeLat = _parseDouble(
                rawData?['latitude'] ?? rawData?['lat'],
              );
              final double? officeLng = _parseDouble(
                rawData?['longitude'] ?? rawData?['lng'],
              );
              final double? radiusMeters = _parseDouble(
                rawData?['radiusMeters'] ??
                    rawData?['radius_meters'] ??
                    rawData?['radius'] ??
                    rawData?['attendanceRadius'],
              );

              final bool hasLocationConfig =
                  officeLat != null && officeLng != null;
              final String coordinateText = hasLocationConfig
                  ? '${officeLat.toStringAsFixed(6)}, ${officeLng.toStringAsFixed(6)}'
                  : 'Belum diatur';
              final String radiusText =
                  (radiusMeters != null && radiusMeters > 0)
                  ? '${radiusMeters.round()} meter'
                  : 'Belum diatur (default 100 meter)';

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
                children: [
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

                  // Ringkasan Jam Kerja & Lokasi Radius Absensi Matrix
                  _MatrixWorkHoursSummaryCard(
                    workStart: matrixStart,
                    workEnd: matrixEnd,
                    isAttendanceEnabled: isAttendanceEnabled,
                    coordinateText: coordinateText,
                    radiusText: radiusText,
                  ),
                  const SizedBox(height: 24),

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
                    icon: Icons.my_location_outlined,
                    label: 'Koordinat & Radius Absensi',
                    value: 'Titik: $coordinateText • Radius: $radiusText',
                  ),
                  _CompanyInfoTile(
                    icon: Icons.info_outline,
                    label: 'Deskripsi',
                    value:
                        company.description ?? 'Belum ada deskripsi perusahaan.',
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _MatrixWorkHoursSummaryCard extends StatelessWidget {
  final String workStart;
  final String workEnd;
  final bool isAttendanceEnabled;
  final String coordinateText;
  final String radiusText;

  const _MatrixWorkHoursSummaryCard({
    required this.workStart,
    required this.workEnd,
    required this.isAttendanceEnabled,
    required this.coordinateText,
    required this.radiusText,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jam Kerja & Lokasi Matrix Sphere',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Jam Operasional: $workStart - $workEnd'),
            const SizedBox(height: 4),
            Text('Titik Koordinat: $coordinateText'),
            const SizedBox(height: 4),
            Text('Batas Radius: $radiusText'),
          ],
        ),
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