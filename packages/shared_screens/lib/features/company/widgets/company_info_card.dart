import 'package:flutter/material.dart';
import '../models/company_profile_model.dart';

class CompanyInfoCard extends StatelessWidget {
  final CompanyProfileModel company;

  const CompanyInfoCard({
    super.key,
    required this.company,
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
            _CompanyDetailTile(
              icon: Icons.business_center,
              label: 'Bidang Usaha',
              value: company.industry,
            ),
            const Divider(),
            _CompanyDetailTile(
              icon: Icons.email,
              label: 'Email Resmi',
              value: company.email,
            ),
            const Divider(),
            _CompanyDetailTile(
              icon: Icons.phone,
              label: 'Telepon / Kontak Kantor',
              value: company.phone,
            ),
            const Divider(),
            _CompanyDetailTile(
              icon: Icons.language,
              label: 'Website',
              value: company.website,
            ),
            const Divider(),
            _CompanyDetailTile(
              icon: Icons.location_on,
              label: 'Alamat Kantor Pusat',
              value: company.address,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CompanyDetailTile({
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