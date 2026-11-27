import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:shared_services/shared_services.dart';

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

  int _parseInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim()) ?? fallback;
  }

  bool _parseBool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is String) {
      final String lower = value.trim().toLowerCase();
      if (lower == 'true') return true;
      if (lower == 'false') return false;
    }
    return fallback;
  }

  String _formatPhotoType(String? rawType) {
    switch (rawType?.trim()) {
      case 'front_selfie':
        return 'Kamera Depan (Selfie)';
      case 'rear_site':
        return 'Kamera Belakang (Bukti Lokasi/Kerja)';
      case 'both':
        return 'Kamera Depan & Belakang';
      default:
        return 'Kamera Depan (Selfie)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference companyRef = rtdbService.ref('company_profile');
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
                  onPressed: () =>
                      AppNavigation.openEditCompanyProfile(context),
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
              if (snapshot.hasData && snapshot.data!.snapshot.value is Map) {
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
              final bool isAttendanceEnabled = _parseBool(
                rawData?['isAttendanceEnabled'],
                fallback: true,
              );

              // Kebutuhan absensi lokasi & kamera perusahaan
              final bool requireLocation = _parseBool(
                rawData?['requireLocationAttendance'],
                fallback: true,
              );
              final bool requirePhoto = _parseBool(
                rawData?['requirePhotoAttendance'],
                fallback: true,
              );
              final bool allowOutsideRadius = _parseBool(
                rawData?['allowOutsideRadius'],
                fallback: false,
              );
              final int graceMinutes = _parseInt(
                rawData?['graceMinutes'],
                fallback: 15,
              );
              final String photoTypeLabel = _formatPhotoType(
                rawData?['photoType']?.toString(),
              );

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

                  // Ringkasan Jam Kerja, Lokasi & Kebutuhan Absensi Matrix
                  _MatrixWorkHoursSummaryCard(
                    workStart: matrixStart,
                    workEnd: matrixEnd,
                    isAttendanceEnabled: isAttendanceEnabled,
                    requireLocation: requireLocation,
                    requirePhoto: requirePhoto,
                    allowOutsideRadius: allowOutsideRadius,
                    graceMinutes: graceMinutes,
                    photoTypeLabel: photoTypeLabel,
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
                    icon: Icons.camera_alt_outlined,
                    label: 'Kebutuhan Lokasi & Kamera',
                    value:
                        'Lokasi: ${requireLocation ? 'Wajib' : 'Opsional'} • '
                        'Kamera: ${requirePhoto ? 'Wajib ($photoTypeLabel)' : 'Opsional'} • '
                        'Luar Radius: ${allowOutsideRadius ? 'Diizinkan (Review)' : 'Ditolak'} • '
                        'Toleransi: $graceMinutes mnt',
                  ),
                  _CompanyInfoTile(
                    icon: Icons.info_outline,
                    label: 'Deskripsi',
                    value:
                        company.description ??
                        'Belum ada deskripsi perusahaan.',
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
  final bool requireLocation;
  final bool requirePhoto;
  final bool allowOutsideRadius;
  final int graceMinutes;
  final String photoTypeLabel;
  final String coordinateText;
  final String radiusText;

  const _MatrixWorkHoursSummaryCard({
    required this.workStart,
    required this.workEnd,
    required this.isAttendanceEnabled,
    required this.requireLocation,
    required this.requirePhoto,
    required this.allowOutsideRadius,
    required this.graceMinutes,
    required this.photoTypeLabel,
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
              'Jam Kerja, Lokasi & Aturan Absensi',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status Absensi: ${isAttendanceEnabled ? 'Aktif' : 'Nonaktif'} • '
              'Toleransi Terlambat: $graceMinutes menit',
            ),
            const SizedBox(height: 4),
            Text('Jam Operasional: $workStart - $workEnd'),
            const SizedBox(height: 4),
            Text('Titik Koordinat: $coordinateText'),
            const SizedBox(height: 4),
            Text('Batas Radius: $radiusText'),
            const SizedBox(height: 4),
            Text(
              'Wajib GPS/Lokasi: ${requireLocation ? 'Ya' : 'Tidak'} • '
              'Luar Radius: ${allowOutsideRadius ? 'Diizinkan' : 'Ditolak'}',
            ),
            const SizedBox(height: 4),
            Text(
              'Wajib Kamera/Foto: ${requirePhoto ? 'Ya ($photoTypeLabel)' : 'Tidak'}',
            ),
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
