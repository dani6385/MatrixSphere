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

  static const Map<int, String> _dayLabels = <int, String>{
    1: 'Senin',
    2: 'Selasa',
    3: 'Rabu',
    4: 'Kamis',
    5: 'Jumat',
    6: 'Sabtu',
    7: 'Minggu',
  };

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
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final String lower = value.toString().trim().toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
    return fallback;
  }

  List<int> _parseWorkDays(dynamic raw) {
    if (raw is List) {
      final List<int> parsed = raw
          .map((e) => int.tryParse(e.toString().trim()) ?? 0)
          .where((d) => d >= 1 && d <= 7)
          .toSet()
          .toList()
        ..sort();
      if (parsed.isNotEmpty) return parsed;
    }
    // Default Senin - Jumat
    return <int>[1, 2, 3, 4, 5];
  }

  String _formatWorkDaysLabel(List<int> days) {
    if (days.length == 5 &&
        days[0] == 1 &&
        days[1] == 2 &&
        days[2] == 3 &&
        days[3] == 4 &&
        days[4] == 5) {
      return 'Senin - Jumat';
    }
    return days.map((d) => _dayLabels[d] ?? '').where((s) => s.isNotEmpty).join(', ');
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
              final List<int> workDays = _parseWorkDays(rawData?['workDays']);
              final String workDaysLabel = _formatWorkDaysLabel(workDays);

              // Dekrit Lembur Matrix Sphere & Kebijakan Lembur
              final bool overtimeDecreeEnabled = _parseBool(
                rawData?['overtimeDecreeEnabled'],
                fallback: false,
              );
              final String overtimeDecreeNumber =
                  rawData?['overtimeDecreeNumber']?.toString().trim() ?? '';
              final String overtimeDecreeNote =
                  rawData?['overtimeDecreeNote']?.toString().trim() ??
                      'Pekerja diperbolehkan mengambil lembur sesuai kebutuhan operasional berdasarkan dekrit resmi Matrix Sphere.';

              final bool allowWeekdayOvertime = _parseBool(
                rawData?['allowWeekdayOvertime'],
                fallback: true,
              );
              final String weekdayOvertimeEnd =
                  rawData?['weekdayOvertimeEnd']?.toString() ?? '21:00';

              final bool allowSaturdayOvertime = _parseBool(
                rawData?['allowSaturdayOvertime'],
                fallback: true,
              );
              final String saturdayStart =
                  rawData?['saturdayOvertimeStart']?.toString() ?? '08:00';
              final String saturdayEnd =
                  rawData?['saturdayOvertimeEnd']?.toString() ?? '17:00';

              final bool allowSundayOvertime = _parseBool(
                rawData?['allowSundayOvertime'],
                fallback: true,
              );
              final String sundayStart =
                  rawData?['sundayOvertimeStart']?.toString() ?? '08:00';
              final String sundayEnd =
                  rawData?['sundayOvertimeEnd']?.toString() ?? '17:00';

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

                  // Ringkasan Hari Kerja (Senin - Jumat), Jam Kerja & Lokasi
                  _MatrixWorkHoursSummaryCard(
                    workDaysLabel: workDaysLabel,
                    workStart: matrixStart,
                    workEnd: matrixEnd,
                    requireLocation: requireLocation,
                    requirePhoto: requirePhoto,
                    allowOutsideRadius: allowOutsideRadius,
                    graceMinutes: graceMinutes,
                    photoTypeLabel: photoTypeLabel,
                    coordinateText: coordinateText,
                    radiusText: radiusText,
                  ),
                  const SizedBox(height: 16),

                  // Kartu Dekrit & Kebijakan Lembur Matrix Sphere
                  _MatrixOvertimeDecreeCard(
                    decreeEnabled: overtimeDecreeEnabled,
                    decreeNumber: overtimeDecreeNumber,
                    decreeNote: overtimeDecreeNote,
                    regularEndTime: matrixEnd,
                    allowWeekdayOvertime: allowWeekdayOvertime,
                    weekdayOvertimeEnd: weekdayOvertimeEnd,
                    allowSaturdayOvertime: allowSaturdayOvertime,
                    saturdayStart: saturdayStart,
                    saturdayEnd: saturdayEnd,
                    allowSundayOvertime: allowSundayOvertime,
                    sundayStart: sundayStart,
                    sundayEnd: sundayEnd,
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
  final String workDaysLabel;
  final String workStart;
  final String workEnd;
  final bool requireLocation;
  final bool requirePhoto;
  final bool allowOutsideRadius;
  final int graceMinutes;
  final String photoTypeLabel;
  final String coordinateText;
  final String radiusText;

  const _MatrixWorkHoursSummaryCard({
    required this.workDaysLabel,
    required this.workStart,
    required this.workEnd,
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
              'Hari Kerja, Lokasi & Aturan Absensi',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hari Kerja Reguler: $workDaysLabel',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text('Jam Operasional Reguler: $workStart - $workEnd'),
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

class _MatrixOvertimeDecreeCard extends StatelessWidget {
  final bool decreeEnabled;
  final String decreeNumber;
  final String decreeNote;
  final String regularEndTime;
  final bool allowWeekdayOvertime;
  final String weekdayOvertimeEnd;
  final bool allowSaturdayOvertime;
  final String saturdayStart;
  final String saturdayEnd;
  final bool allowSundayOvertime;
  final String sundayStart;
  final String sundayEnd;

  const _MatrixOvertimeDecreeCard({
    required this.decreeEnabled,
    required this.decreeNumber,
    required this.decreeNote,
    required this.regularEndTime,
    required this.allowWeekdayOvertime,
    required this.weekdayOvertimeEnd,
    required this.allowSaturdayOvertime,
    required this.saturdayStart,
    required this.saturdayEnd,
    required this.allowSundayOvertime,
    required this.sundayStart,
    required this.sundayEnd,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: decreeEnabled
          ? colorScheme.primaryContainer.withValues(alpha: 0.25)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: decreeEnabled
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
                  decreeEnabled
                      ? Icons.gavel_rounded
                      : Icons.event_busy_outlined,
                  color: decreeEnabled
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dekrit & Jadwal Lembur Matrix Sphere',
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
                    color: decreeEnabled
                        ? Colors.green.withValues(alpha: 0.15)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    decreeEnabled ? 'DEKRIT AKTIF' : 'NONAKTIF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: decreeEnabled
                          ? Colors.green.shade800
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            if (decreeNumber.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Nomor / Kode Dekrit: $decreeNumber',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              decreeEnabled
                  ? decreeNote
                  : 'Saat ini belum ada dekrit lembur aktif. Pekerja hanya mengikuti jam kerja reguler Senin - Jumat.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (decreeEnabled) ...[
              const Divider(height: 20),
              Text(
                '• Lembur Hari Kerja (Senin - Jumat): '
                '${allowWeekdayOvertime ? 'Diizinkan setelah $regularEndTime s.d. $weekdayOvertimeEnd' : 'Tidak berlaku'}',
              ),
              const SizedBox(height: 4),
              Text(
                '• Lembur Hari Sabtu: '
                '${allowSaturdayOvertime ? 'Diizinkan ($saturdayStart - $saturdayEnd)' : 'Libur / Tidak berlaku'}',
              ),
              const SizedBox(height: 4),
              Text(
                '• Lembur Hari Minggu: '
                '${allowSundayOvertime ? 'Diizinkan ($sundayStart - $sundayEnd)' : 'Libur / Tidak berlaku'}',
              ),
            ],
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