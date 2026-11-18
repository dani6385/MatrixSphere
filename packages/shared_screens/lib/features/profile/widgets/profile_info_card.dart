import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';

class ProfileInfoCard extends StatelessWidget {
  final UserProfileModel profile;

  const ProfileInfoCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _ProfileDetailTile(
              icon: Icons.badge,
              label: 'Jabatan / Role',
              value: profile.role,
            ),
            const Divider(),
            _ProfileDetailTile(
              icon: Icons.phone,
              label: 'Nomor HP / WhatsApp',
              value: profile.phone,
            ),
            const Divider(),
            _ProfileDetailTile(
              icon: Icons.location_on,
              label: 'Alamat',
              value: profile.address,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade50,
        child: Icon(icon, color: Colors.blue, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}