// lib/screens/Attendance/widgets/attendance_card_content.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../models/attendance_schedule_state.dart';

class AttendanceCardContent extends StatelessWidget {
  final String title;
  final String envLabel;
  final String todayKey;
  final String workStartTime;
  final String workEndTime;
  final String? checkInTime;
  final String? checkOutTime;
  final AttendanceStatusDisplay statusDisplay;
  final bool isSaving;
  final VoidCallback onActionTap;

  const AttendanceCardContent({
    super.key,
    required this.title,
    required this.envLabel,
    required this.todayKey,
    required this.workStartTime,
    required this.workEndTime,
    required this.checkInTime,
    required this.checkOutTime,
    required this.statusDisplay,
    required this.isSaving,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$title • $envLabel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: kDarkTextPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  todayKey,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Jam Kerja Matrix: $workStartTime - $workEndTime',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusDisplay.statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: statusDisplay.statusColor.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    statusDisplay.statusIcon,
                    color: statusDisplay.statusColor,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusDisplay.statusTitle,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: statusDisplay.statusColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          statusDisplay.statusSubtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: kDarkTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jam Masuk: ${checkInTime ?? '--:--'}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: kDarkTextPrimary,
                    ),
                  ),
                  Text(
                    'Jam Pulang: ${checkOutTime ?? '--:--'}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: kDarkTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: statusDisplay.isButtonDisabled ? null : onActionTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: statusDisplay.buttonColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(statusDisplay.buttonIcon),
              label: Text(
                isSaving ? 'Menyimpan...' : statusDisplay.buttonLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}