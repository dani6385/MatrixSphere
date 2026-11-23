// lib/features/profile/user_profile.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/screens/Attendance/helpers/work_schedule_helper.dart';

import 'edit_profile.dart';

class UserProfileScreen extends StatelessWidget {
  final String? targetUid;

  const UserProfileScreen({
    super.key,
    this.targetUid,
  });

  String _formatIndonesianDate(DateTime? date) {
    if (date == null) return 'Belum diatur';
    const List<String> months = <String>[
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final String day = date.day.toString().padLeft(2, '0');
    return '$day ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? uid = targetUid ?? currentUser?.uid;

    if (uid == null || uid.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil Pengguna')),
        body: const Center(
          child: Text('Silakan login terlebih dahulu untuk melihat profil.'),
        ),
      );
    }

    final DatabaseReference matrixUserRef = FirebaseDatabase.instance.ref(
      'attendance/matrix/$uid',
    );
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return StreamBuilder<DatabaseEvent>(
      stream: matrixUserRef.onValue,
      builder: (context, snapshot) {
        Map<dynamic, dynamic> matrixData = <dynamic, dynamic>{};
        if (snapshot.hasData && snapshot.data!.snapshot.value is Map) {
          matrixData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        }

        final String displayName =
            (matrixData['name']?.toString().trim().isNotEmpty == true)
                ? matrixData['name'].toString().trim()
                : (currentUser?.displayName?.trim().isNotEmpty == true
                    ? currentUser!.displayName!.trim()
                    : 'Pengguna Matrix Sphere');

        final String email =
            (matrixData['email']?.toString().trim().isNotEmpty == true)
                ? matrixData['email'].toString().trim()
                : (currentUser?.email?.trim().isNotEmpty == true
                    ? currentUser!.email!.trim()
                    : 'Belum diatur');

        final String phone =
            matrixData['phone']?.toString().trim().isNotEmpty == true
                ? matrixData['phone'].toString().trim()
                : 'Belum diatur';

        final String role =
            matrixData['role']?.toString().trim().isNotEmpty == true
                ? matrixData['role'].toString().trim()
                : 'Staf / Karyawan';

        final DateTime? parsedStartDate = WorkScheduleHelper.parseDate(
          matrixData['startDate'] ?? matrixData['start_date'],
        );
        final String startDateKey = parsedStartDate != null
            ? WorkScheduleHelper.toDateKey(parsedStartDate)
            : (matrixData['startDate']?.toString().trim() ?? '-');
        final String startDateLabel = parsedStartDate != null
            ? '${_formatIndonesianDate(parsedStartDate)} ($startDateKey)'
            : 'Belum diatur';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Pengguna'),
            actions: [
              IconButton(
                tooltip: 'Edit Profil',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => EditProfileScreen(
                        uid: uid,
                        initialName: displayName,
                        initialEmail: email == 'Belum diatur' ? '' : email,
                        initialPhone: phone == 'Belum diatur' ? '' : phone,
                        initialRole: role,
                        initialStartDate:
                            parsedStartDate ?? DateTime(2026, 11, 22),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Text(
                              displayName.isNotEmpty
                                  ? displayName[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            displayName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _ProfileInfoCard(
                      icon: Icons.event_available_outlined,
                      label: 'Tanggal Mulai Bekerja',
                      value: startDateLabel,
                    ),
                    _ProfileInfoCard(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: email,
                    ),
                    _ProfileInfoCard(
                      icon: Icons.phone_outlined,
                      label: 'Telepon',
                      value: phone,
                    ),
                    _ProfileInfoCard(
                      icon: Icons.badge_outlined,
                      label: 'User ID (UID)',
                      value: uid,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoCard({
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