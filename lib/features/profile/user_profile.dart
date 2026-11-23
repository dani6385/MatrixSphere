// lib/features/profile/user_profile.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'edit_profile.dart';

class UserProfileScreen extends StatelessWidget {
  final String? targetUid;

  const UserProfileScreen({
    super.key,
    this.targetUid,
  });

  /// Menghitung lama masa kerja dari startDate hingga hari ini
  String _calculateTenure(DateTime startDate) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    if (startDate.isAfter(today)) {
      final int daysUntil = startDate.difference(today).inDays;
      return 'Mulai dalam $daysUntil hari';
    }

    int years = today.year - startDate.year;
    int months = today.month - startDate.month;
    int days = today.day - startDate.day;

    if (days < 0) {
      months -= 1;
      final DateTime prevMonth = DateTime(today.year, today.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    final List<String> parts = <String>[];
    if (years > 0) parts.add('$years tahun');
    if (months > 0) parts.add('$months bulan');
    if (days > 0 || parts.isEmpty) parts.add('$days hari');

    return parts.join(' ');
  }

  String _readString(Map<dynamic, dynamic> map, String key, String fallback) {
    final String? val = map[key]?.toString().trim();
    return (val != null && val.isNotEmpty) ? val : fallback;
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

    // Membaca data profil & kepegawaian dari matrix_member/$uid
    final DatabaseReference memberRef = FirebaseDatabase.instance.ref(
      'matrix_member/$uid',
    );
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return StreamBuilder<DatabaseEvent>(
      stream: memberRef.onValue,
      builder: (context, snapshot) {
        Map<dynamic, dynamic> memberData = <dynamic, dynamic>{};
        if (snapshot.hasData && snapshot.data!.snapshot.value is Map) {
          memberData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        }

        final String displayName = _readString(
          memberData,
          'name',
          (currentUser?.displayName?.trim().isNotEmpty == true)
              ? currentUser!.displayName!.trim()
              : 'Pengguna Matrix Sphere',
        );

        final String employeeId =
            _readString(memberData, 'employeeId', 'Belum diatur');
        final String department =
            _readString(memberData, 'department', 'Belum diatur');
        final String role =
            _readString(memberData, 'role', 'Staf / Karyawan');
        final String employmentStatus =
            _readString(memberData, 'employmentStatus', 'Belum diatur');

        final String email = _readString(
          memberData,
          'email',
          (currentUser?.email?.trim().isNotEmpty == true)
              ? currentUser!.email!.trim()
              : 'Belum diatur',
        );

        final String phone = _readString(memberData, 'phone', 'Belum diatur');
        final String address =
            _readString(memberData, 'address', 'Belum diatur');

        final String rawStartDate =
            _readString(memberData, 'startDate', '');
        final DateTime? parsedStartDate = parseIsoDate(rawStartDate);
        final String startDateDisplay = parsedStartDate != null
            ? '${formatIndonesianDate(parsedStartDate)} (${_calculateTenure(parsedStartDate)})'
            : 'Belum diatur';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Pekerja'),
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
                        initialEmployeeId:
                            employeeId == 'Belum diatur' ? '' : employeeId,
                        initialEmail: email == 'Belum diatur' ? '' : email,
                        initialPhone: phone == 'Belum diatur' ? '' : phone,
                        initialDepartment:
                            department == 'Belum diatur' ? '' : department,
                        initialRole: role,
                        initialEmploymentStatus: employmentStatus,
                        initialAddress:
                            address == 'Belum diatur' ? '' : address,
                        initialStartDate: parsedStartDate,
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
                            department != 'Belum diatur'
                                ? '$role • $department'
                                : role,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (employmentStatus != 'Belum diatur') ...[
                            const SizedBox(height: 8),
                            Chip(
                              label: Text(employmentStatus),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Informasi Kepegawaian',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _ProfileInfoCard(
                      icon: Icons.event_available_outlined,
                      label: 'Tanggal Mulai Bekerja & Masa Kerja',
                      value: startDateDisplay,
                    ),
                    _ProfileInfoCard(
                      icon: Icons.badge_outlined,
                      label: 'NIP / ID Karyawan',
                      value: employeeId,
                    ),
                    _ProfileInfoCard(
                      icon: Icons.apartment_outlined,
                      label: 'Departemen / Divisi',
                      value: department,
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Kontak & Identitas Sistem',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _ProfileInfoCard(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: email,
                    ),
                    _ProfileInfoCard(
                      icon: Icons.phone_outlined,
                      label: 'Telepon / WhatsApp',
                      value: phone,
                    ),
                    _ProfileInfoCard(
                      icon: Icons.location_on_outlined,
                      label: 'Alamat Domisili',
                      value: address,
                    ),
                    _ProfileInfoCard(
                      icon: Icons.fingerprint_outlined,
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
      margin: const EdgeInsets.only(bottom: 10),
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