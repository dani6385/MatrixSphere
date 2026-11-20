// lib/screens/attendance/widgets/attendance_body.dart

import 'package:flutter/material.dart';

class AttendanceBody extends StatelessWidget {
  final bool isCameraInitialized;
  final bool isLoadingLocation;
  final bool isInRange;
  final double distanceToOffice;
  final bool isProcessing;
  final VoidCallback? onSubmit;

  const AttendanceBody({
    super.key,
    required this.isCameraInitialized,
    required this.isLoadingLocation,
    required this.isInRange,
    required this.distanceToOffice,
    required this.isProcessing,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
      ],
    );
  }
}