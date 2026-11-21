// lib/features/company/company_profile_screen.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

import 'models/company_profile_model.dart';

/// Halaman Profil Perusahaan (`CompanyProfile`) untuk Seller Sphere / Matrix Sphere.
/// Membaca data real-time dari node `company_profile` di Firebase Realtime Database
/// serta menyediakan pengaturan Jam Kerja (Jam Masuk & Jam Pulang) dan status absensi.
class CompanyProfile extends StatelessWidget {
  const CompanyProfile({super.key});

  String _formatTimeOfDay(TimeOfDay time) {
    final String hh = time.hour.toString().padLeft(2, '0');
    final String mm = time.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  TimeOfDay _parseTimeString(String? raw, TimeOfDay fallback) {
    if (raw == null || !raw.contains(':')) return fallback;
    final List<String> parts = raw.split(':');
    if (parts.length < 2) return fallback;
    final int? hour = int.tryParse(parts[0]);
    final int? minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return fallback;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return fallback;
    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Membuka dialog untuk menetapkan jam kerja & status aktif absensi di `company_profile`.
  Future<void> _openWorkHoursDialog({
    required BuildContext context,
    required DatabaseReference companyRef,
    required String currentStartTime,
    required String currentEndTime,
    required bool currentAttendanceEnabled,
  }) async {
    TimeOfDay selectedStart =
        _parseTimeString(currentStartTime, const TimeOfDay(hour: 8, minute: 0));
    TimeOfDay selectedEnd =
        _parseTimeString(currentEndTime, const TimeOfDay(hour: 17, minute: 0));
    bool attendanceEnabled = currentAttendanceEnabled;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext ctx, void Function(void Function()) setLocalState) {
            return AlertDialog(
              title: const Text('Pengaturan Jam Kerja'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.login),
                    title: const Text('Jam Masuk Kerja'),
                    trailing: TextButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: ctx,
                          initialTime: selectedStart,
                        );
                        if (picked != null) {
                          setLocalState(() => selectedStart = picked);
                        }
                      },
                      child: Text(
                        _formatTimeOfDay(selectedStart),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout),
                    title: const Text('Jam Pulang Kerja'),
                    trailing: TextButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: ctx,
                          initialTime: selectedEnd,
                        );
                        if (picked != null) {
                          setLocalState(() => selectedEnd = picked);
                        }
                      },
                      child: Text(
                        _formatTimeOfDay(selectedEnd),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Aktifkan Absensi Pekerja'),
                    value: attendanceEnabled,
                    onChanged: (bool val) {
                      setLocalState(() => attendanceEnabled = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBrandPrimary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final String startStr = _formatTimeOfDay(selectedStart);
                    final String endStr = _formatTimeOfDay(selectedEnd);

                    await companyRef.update(<String, dynamic>{
                      'workStartTime': startStr,
                      'workEndTime': endStr,
                      'isAttendanceEnabled': attendanceEnabled,
                    });

                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Jam kerja disimpan ($startStr - $endStr)',
                          ),
                          backgroundColor: kBrandPrimary,
                        ),
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference companyRef =
        FirebaseDatabase.instance.ref('company_profile');
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Perusahaan'),
        actions: [
          IconButton(
            tooltip: 'Atur Jam Kerja',
            icon: const Icon(Icons.schedule_outlined),
            onPressed: () async {
              final DataSnapshot snap = await companyRef.get();
              Map<dynamic, dynamic> map = <dynamic, dynamic>{};
              if (snap.value is Map<dynamic, dynamic>) {
                map = snap.value as Map<dynamic, dynamic>;
              }
              if (!context.mounted) return;
              await _openWorkHoursDialog(
                context: context,
                companyRef: companyRef,
                currentStartTime: map['workStartTime']?.toString() ?? '08:00',
                currentEndTime: map['workEndTime']?.toString() ?? '17:00',
                currentAttendanceEnabled: map['isAttendanceEnabled'] is bool
                    ? map['isAttendanceEnabled'] as bool
                    : true,
              );
            },
          ),
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

          final CompanyProfileModel company = CompanyProfileModel.fromMap(rawData);
          final String workStartTime =
              rawData?['workStartTime']?.toString() ?? '08:00';
          final String workEndTime =
              rawData?['workEndTime']?.toString() ?? '17:00';
          final bool isAttendanceEnabled =
              rawData?['isAttendanceEnabled'] is bool
                  ? rawData!['isAttendanceEnabled'] as bool
                  : true;

          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // Kartu Avatar & Identitas Utama Perusahaan
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage:
                          company.hasLogo ? NetworkImage(company.logoUrl!) : null,
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

              // Detail Jam Kerja & Pengaturan Absensi Pekerja
              _CompanyInfoTile(
                icon: Icons.access_time,
                label: 'Jam Kerja (Masuk - Pulang)',
                value:
                    '$workStartTime - $workEndTime (${isAttendanceEnabled ? "Absensi Aktif" : "Absensi Nonaktif"})',
              ),
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