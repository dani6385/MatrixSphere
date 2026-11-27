import 'package:flutter/material.dart';

import '../../models/attendance_rule_model.dart';
import '../../models/company_profile_model.dart';

class CompanyHeaderWidget extends StatelessWidget {
  final CompanyProfileModel company;
  final AttendanceRuleModel? rule;

  const CompanyHeaderWidget({super.key, required this.company, this.rule});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    const double bannerHeight = 184;
    const double avatarRadius = 46;
    const double avatarOverlap = 36;

    final String statusLabel = (rule?.isAttendanceEnabled ?? true)
        ? 'Absensi Aktif • ${rule?.workStart ?? '08:00'} - ${rule?.workEnd ?? '17:00'}'
        : 'Absensi Nonaktif';

    return Column(
      children: [
        SizedBox(
          height: bannerHeight + avatarOverlap,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: bannerHeight,
                  width: double.infinity,
                  child: company.hasBanner
                      ? Image.network(
                          company.bannerUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 38,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: Icon(
                              Icons.panorama_outlined,
                              size: 42,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.scaffoldBackgroundColor,
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: company.hasLogo
                        ? NetworkImage(company.logoUrl!)
                        : null,
                    child: !company.hasLogo
                        ? Icon(
                            Icons.apartment,
                            size: 40,
                            color: colorScheme.primary,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Text(
            statusLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
