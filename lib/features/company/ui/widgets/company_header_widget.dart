import 'package:flutter/material.dart';

import '../../models/company_profile_model.dart';

class CompanyHeaderWidget extends StatelessWidget {
  final CompanyProfileModel company;

  const CompanyHeaderWidget({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
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
    );
  }
}