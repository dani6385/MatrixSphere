// lib/features/profile/widgets/user_profile_body.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'profile_info_card.dart';

class UserProfileBody extends StatelessWidget {
  final bool isLoading;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String bannerUrl;
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
    required this.photoUrl,
    required this.bannerUrl,
    required this.role,
    required this.department,
    required this.employmentStatus,
    required this.startDateDisplay,
    required this.employeeId,
    required this.email,
    required this.phone,
    required this.address,
  });
//dari sini
String _buildInitials(String name) {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final List<String> parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed[0].toUpperCase();
  }
  /// Membangun bagian banner / background profil di bagian paling atas
  Widget _buildBannerHeader(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool hasBanner = bannerUrl.trim().isNotEmpty;

    return SizedBox(
      height: 165,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasBanner)
            Image.network(
              bannerUrl.trim(),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: colors.surfaceContainerHighest,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: colors.onSurfaceVariant,
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    colors.primaryContainer,
                    colors.surfaceContainerHighest,
                  ],
                ),
              ),
            ),
          // Lapisan gelap tipis agar kontras teks/elemen di atas banner tetap jelas
          Container(
            color: Colors.black.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
  Widget _buildAvatar(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool hasPhoto = photoUrl.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: CircleAvatar(
        radius: 44,
        backgroundColor: colors.primary,
        backgroundImage: hasPhoto ? NetworkImage(photoUrl.trim()) : null,
        child: !hasPhoto
            ? Text(
                _buildInitials(displayName),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimary,
                ),
              )
            : null,
      ),
    );
  }
  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: colors.primary),
        title: Text(
          title,
          style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
//sampai sini
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Gabungan banner di atas dan avatar bertumpuk di bawahnya
        Stack(
       //clipBehavior: CollectiveOverflowBehavior.none,
          alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                _buildBannerHeader(context),
                const SizedBox(height: 48),
              ],
            ),
            Positioned(
              top: 115,
              child: _buildAvatar(context),
            ),
          ],
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
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.darkAppBar),
        ),
        const SizedBox(height: 8),
        Center(
          child: Chip(
            label: Text(employmentStatus),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Kepegawaian',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInfoTile(
                context: context,
                icon: Icons.event_available_outlined,
                title: 'Tanggal Mulai Bekerja & Masa Kerja',
                value: startDateDisplay,
              ),
              _buildInfoTile(
                context: context,
                icon: Icons.badge_outlined,
                title: 'NIP / ID Karyawan',
                value: employeeId,
              ),
              _buildInfoTile(
                context: context,
                icon: Icons.apartment_outlined,
                title: 'Departemen / Divisi',
                value: department,
              ),
              const SizedBox(height: 10),
              const Text(
                'Kontak & Identitas Sistem',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInfoTile(
                context: context,
                icon: Icons.email_outlined,
                title: 'Email',
                value: email,
              ),
              _buildInfoTile(
                context: context,
                icon: Icons.phone_outlined,
                title: 'Telepon / WhatsApp',
                value: phone,
              ),
              _buildInfoTile(
                context: context,
                icon: Icons.location_on_outlined,
                title: 'Alamat Domisili',
                value: address,
              ),
              const SizedBox(height: 20),
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
