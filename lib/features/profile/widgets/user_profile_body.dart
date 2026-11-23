// lib/features/profile/widgets/user_profile_body.dart

import 'package:flutter/material.dart';

import 'profile_info_card.dart';

class UserProfileBody extends StatelessWidget {
  final bool isLoading;
  final String uid;
  final String displayName;
  final String role;
  final String department;
  final String employmentStatus;
  final String startDateDisplay;
  final String employeeId;
  final String email;
  final String phone;
  final String address;

  const UserProfileBody({
    super.key,
    required this.isLoading,
    required this.uid,
    required this.displayName,
    required this.role,
    required this.department,
    required this.employmentStatus,
    required this.startDateDisplay,
    required this.employeeId,
    required this.email,
    required this.phone,
    required this.address,
    required String photoUrl,
    required String bannerUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
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
                department != 'Belum diatur' ? '$role • $department' : role,
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        ProfileInfoCard(
          icon: Icons.event_available_outlined,
          label: 'Tanggal Mulai Bekerja & Masa Kerja',
          value: startDateDisplay,
        ),
        ProfileInfoCard(
          icon: Icons.badge_outlined,
          label: 'NIP / ID Karyawan',
          value: employeeId,
        ),
        ProfileInfoCard(
          icon: Icons.apartment_outlined,
          label: 'Departemen / Divisi',
          value: department,
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Kontak & Identitas Sistem',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        ProfileInfoCard(
          icon: Icons.email_outlined,
          label: 'Email',
          value: email,
        ),
        ProfileInfoCard(
          icon: Icons.phone_outlined,
          label: 'Telepon / WhatsApp',
          value: phone,
        ),
        ProfileInfoCard(
          icon: Icons.location_on_outlined,
          label: 'Alamat Domisili',
          value: address,
        ),
        ProfileInfoCard(
          icon: Icons.fingerprint_outlined,
          label: 'User ID (UID)',
          value: uid,
        ),
      ],
    );
  }
}
