// lib/screens/Attendance/widgets/attendance_action_card.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../models/attendance_paths.dart';
import '../models/attendance_radius_config.dart';
import '../models/attendance_schedule_state.dart';
import '../services/attendance_location_service.dart';
import '../services/attendance_rtdb_service.dart';
import 'attendance_card_content.dart';
import 'attendance_dialogs.dart';

/// Wadah utama kartu absensi 1 tombol (Check-In & Check-Out) khusus **Matrix Sphere**.
class AttendanceActionCard extends StatefulWidget {
  final String title;

  const AttendanceActionCard({super.key, this.title = 'Absensi Kerja'});

  @override
  State<AttendanceActionCard> createState() => _AttendanceActionCardState();
}

class _AttendanceActionCardState extends State<AttendanceActionCard> {
  final AttendanceRtdbService _rtdbService = AttendanceRtdbService();
  final AttendanceLocationService _locationService =
      AttendanceLocationService();

  bool _isSaving = false;
  late String _activeDateKey;
  Timer? _clockCheckTimer;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _activeDateKey = AttendanceScheduleEvaluator.getDateKey(now);
    _rtdbService.handleMidnightTransitionIfNeeded(now);

    // Periksa waktu berjalan & pergantian hari setiap 15 detik
    _clockCheckTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (!mounted) return;
      final DateTime currentNow = DateTime.now();
      final String latestKey = AttendanceScheduleEvaluator.getDateKey(
        currentNow,
      );
      if (latestKey != _activeDateKey) {
        _rtdbService.handleMidnightTransitionIfNeeded(currentNow);
        setState(() {
          _activeDateKey = latestKey;
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _clockCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleAttendanceTap({
    required User user,
    required DatabaseReference todayRef,
    required bool isCheckOutStep,
    required String dateKey,
    required AttendanceScheduleEvaluator schedule,
    required AttendanceRadiusConfig radiusConfig,
  }) async {
    if (_isSaving) return;

    bool isOvertime = false;
    if (isCheckOutStep) {
      final bool? confirmedOvertime =
          await AttendanceDialogs.showOvertimeConfirmation(
        context,
        workEndTime: schedule.workEndTime,
        closeTimeText: schedule.checkOutCloseText,
      );
      if (confirmedOvertime == null) return;
      isOvertime = confirmedOvertime;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final AttendanceLocationData locationData =
          await _locationService.getCurrentLocation();

      final AttendanceRadiusCheckResult radiusResult = locationData.checkRadius(
        currentLocation: locationData,
        radiusConfig: radiusConfig,
      );

      if (!radiusResult.isWithinRadius) {
        _showSnackBar(
          'Di luar radius kantor (${radiusResult.distanceText} dari titik kantor; maksimal ${radiusResult.allowedRadiusText}). Absensi ditolak.',
          isError: true,
        );
        return;
      }

      final AttendanceLocationData verifiedLocation =
          locationData.withRadiusInfo(
        distanceToOfficeMeters: radiusResult.distanceMeters,
        allowedRadiusMeters: radiusResult.allowedRadiusMeters,
      );

      final DateTime now = DateTime.now();
      final String formattedTime = AttendanceScheduleEvaluator.formatTime(now);
      final String userName = await _rtdbService.resolveUserName(user);

      if (!isCheckOutStep) {
        final int lateMinutes = schedule.calculateLateMinutes(now);
        final bool isLate = lateMinutes > 0;
        final String lateDurationText =
            AttendanceScheduleEvaluator.formatLateDuration(lateMinutes);

        await _rtdbService.recordCheckIn(
          user: user,
          userName: userName,
          todayRef: todayRef,
          dateKey: dateKey,
          formattedTime: formattedTime,
          lateMinutes: lateMinutes,
          location: verifiedLocation,
        );

        if (isLate) {
          _showSnackBar(
            'Check-In dicatat pukul $formattedTime (Terlambat sekitar $lateDurationText)',
            isError: true,
          );
          if (mounted) {
            await AttendanceDialogs.showLateWarning(
              context,
              lateDurationText: lateDurationText,
            );
          }
        } else {
          _showSnackBar('Check-In berhasil dicatat pukul $formattedTime');
        }
      } else {
        await _rtdbService.recordCheckOut(
          user: user,
          userName: userName,
          todayRef: todayRef,
          dateKey: dateKey,
          formattedTime: formattedTime,
          isOvertime: isOvertime,
          location: verifiedLocation,
        );

        _showSnackBar(
          isOvertime
              ? 'Check-Out (Lembur) berhasil dicatat pukul $formattedTime'
              : 'Check-Out berhasil dicatat pukul $formattedTime',
        );
      }
    } on AttendanceLocationException catch (e) {
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      _showSnackBar('Gagal menyimpan absensi: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : kBrandPrimary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _resolveWorkTime({
    required Map<dynamic, dynamic> companyData,
    required Map<dynamic, dynamic> scheduleData,
    required String companyKey,
    required String scheduleKey,
    required String fallback,
  }) {
    final String fromCompany = companyData[companyKey]?.toString().trim() ?? '';
    if (fromCompany.isNotEmpty) return fromCompany;

    final String fromSchedule =
        scheduleData[scheduleKey]?.toString().trim() ?? '';
    if (fromSchedule.isNotEmpty) return fromSchedule;

    return fallback;
  }

  Map<dynamic, dynamic> _asMap(AsyncSnapshot<DatabaseEvent> snapshot) {
    final Object? val = snapshot.data?.snapshot.value;
    if (snapshot.hasData && val != null && val is Map<dynamic, dynamic>) {
      return val;
    }
    return <dynamic, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String todayKey = _activeDateKey;
    const String envLabel = 'Matrix Sphere';

    if (user == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Silakan login terlebih dahulu untuk melakukan absensi.'),
        ),
      );
    }

    final DatabaseReference companyProfileRef = FirebaseDatabase.instance.ref(
      'company_profile',
    );
    final DatabaseReference legacyScheduleRef = FirebaseDatabase.instance.ref(
      AttendancePaths.workSchedule(),
    );
    final DatabaseReference todayRef = FirebaseDatabase.instance.ref(
      AttendancePaths.attendanceDay(uid: user.uid, dateKey: todayKey),
    );

    return StreamBuilder<DatabaseEvent>(
      stream: companyProfileRef.onValue,
      builder: (context, companySnapshot) {
        final Map<dynamic, dynamic> companyData = _asMap(companySnapshot);
        final AttendanceRadiusConfig radiusConfig =
            AttendanceRadiusConfig.fromCompanyMap(companyData);

        return StreamBuilder<DatabaseEvent>(
          stream: legacyScheduleRef.onValue,
          builder: (context, scheduleSnapshot) {
            final Map<dynamic, dynamic> scheduleData = _asMap(scheduleSnapshot);

            final String workStartTime = _resolveWorkTime(
              companyData: companyData,
              scheduleData: scheduleData,
              companyKey: 'matrixSphereWorkStart',
              scheduleKey: 'workStartTime',
              fallback: '08:00',
            );
            final String workEndTime = _resolveWorkTime(
              companyData: companyData,
              scheduleData: scheduleData,
              companyKey: 'matrixSphereWorkEnd',
              scheduleKey: 'workEndTime',
              fallback: '17:00',
            );

            return StreamBuilder<DatabaseEvent>(
              stream: todayRef.onValue,
              builder: (context, attendanceSnapshot) {
                final Map<dynamic, dynamic> data = _asMap(attendanceSnapshot);

                final String? checkInTime = data['checkInTime']?.toString();
                final String? checkOutTime = data['checkOutTime']?.toString();
                final String? recordedStatus = data['status']?.toString();
                final bool isLateToday = data['isLate'] == true;
                final int lateMinutesToday =
                    int.tryParse(data['lateMinutes']?.toString() ?? '0') ?? 0;

                final bool hasCheckedIn =
                    checkInTime != null && checkInTime.trim().isNotEmpty;
                final bool hasCheckedOut =
                    checkOutTime != null && checkOutTime.trim().isNotEmpty;

                final bool isCheckOutStep = hasCheckedIn && !hasCheckedOut;
                final bool isCompleted = hasCheckedIn && hasCheckedOut;

                final AttendanceScheduleEvaluator schedule =
                    AttendanceScheduleEvaluator.fromSchedule(
                  workStartTime: workStartTime,
                  workEndTime: workEndTime,
                  now: DateTime.now(),
                );

                final AttendanceStatusDisplay statusDisplay =
                    AttendanceStatusDisplay.resolve(
                  schedule: schedule,
                  isCompleted: isCompleted,
                  isCheckOutStep: isCheckOutStep,
                  isSaving: _isSaving,
                  checkInTime: checkInTime,
                  recordedStatus: recordedStatus,
                  isLateToday: isLateToday,
                  lateMinutesToday: lateMinutesToday,
                );

                return AttendanceCardContent(
                  title: widget.title,
                  envLabel: envLabel,
                  todayKey: todayKey,
                  workStartTime: workStartTime,
                  workEndTime: workEndTime,
                  checkInTime: checkInTime,
                  checkOutTime: checkOutTime,
                  statusDisplay: statusDisplay,
                  isSaving: _isSaving,
                  onActionTap: () => _handleAttendanceTap(
                    user: user,
                    todayRef: todayRef,
                    isCheckOutStep: isCheckOutStep,
                    dateKey: todayKey,
                    schedule: schedule,
                    radiusConfig: radiusConfig,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}