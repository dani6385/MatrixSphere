
// lib/screens/attendance/widgets/attendance_body.dart


import 'package:flutter/material.dart';

import 'package:shared_ui/shared_ui.dart';

class AttendanceBody extends StatelessWidget {
  final bool isScanning;
  final bool hasCameraPermission;
  final bool isCheckingLocation;
  
  final Animation<double> laserAnimation;
  final String scanStatusMessage;
  final double scanProgress;
  final VoidCallback onCancelScan;
  final VoidCallback onRequestPermission;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;
  
  final VoidCallback onSync;

  const AttendanceBody({
    super.key,
    required this.isScanning,
    required this.hasCameraPermission,
    required this.isCheckingLocation,
    
    required this.laserAnimation,
    required this.scanStatusMessage,
    required this.scanProgress,
    required this.onCancelScan,
    required this.onRequestPermission,
    required this.onClockIn,
    required this.onClockOut,
    
    required this.onSync, required Future<void> Function() onOfficeClockIn, required Future<void> Function() onOfficeClockOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.surface,
            context.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          
          const SizedBox(height: 16),
         
          const SizedBox(height: 24),
          
          const SizedBox(height: 8),
          
        ],
      ),
    );
  }

}