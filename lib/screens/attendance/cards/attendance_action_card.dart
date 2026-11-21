// lib/screens/Attendance/widgets/attendance_action_card.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Kartu absensi mandiri dengan 1 tombol (Check-In & Check-Out):
/// 1. Terhubung ke Firebase RTDB (`history_attendance/{uid}/{YYYY-MM-DD}`).
/// 2. Otomatis reset pada pukul 00:00 untuk siap Check-In di hari berikutnya.
/// 3. Mengikuti pengaturan aktif/nonaktif dari node `company_profile`.
class AttendanceActionCard extends StatefulWidget {
  final String title;

  const AttendanceActionCard({
    super.key,
    this.title = 'Absensi Kerja Harian',
  });

  @override
  State<AttendanceActionCard> createState() => _AttendanceActionCardState();
}

class _AttendanceActionCardState extends State<AttendanceActionCard> {
  bool _isSaving = false;
  late String _activeDateKey;
  Timer? _midnightCheckTimer;

  @override
  void initState() {
    super.initState();
    _activeDateKey = _getTodayDateKey(DateTime.now());

    // Cek pergantian tanggal setiap 30 detik agar otomatis reset tepat saat 00:00
    _midnightCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final String latestKey = _getTodayDateKey(DateTime.now());
      if (latestKey != _activeDateKey && mounted) {
        setState(() {
          _activeDateKey = latestKey;
        });
      }
    });
  }

  @override
  void dispose() {
    _midnightCheckTimer?.cancel();
    super.dispose();
  }

  /// Menghasilkan kunci tanggal dengan format `YYYY-MM-DD`.
  String _getTodayDateKey(DateTime now) {
    final String yyyy = now.year.toString().padLeft(4, '0');
    final String mm = now.month.toString().padLeft(2, '0');
    final String dd = now.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  /// Memformat waktu menjadi `HH:mm`.
  String _formatTime(DateTime now) {
    final String hh = now.hour.toString().padLeft(2, '0');
    final String mm = now.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  /// Menyimpan data Check-In atau Check-Out ke Firebase Realtime Database.
  Future<void> _handleAttendanceTap({
    required DatabaseReference todayRef,
    required bool isCheckOutStep,
    required String dateKey,
  }) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final DateTime now = DateTime.now();
      final String formattedTime = _formatTime(now);

      if (!isCheckOutStep) {
        await todayRef.set(<String, dynamic>{
          'date': dateKey,
          'checkInTime': formattedTime,
          'checkInTimestamp': ServerValue.timestamp,
          'checkOutTime': null,
          'status': 'checked_in',
        });
        _showSnackBar('Check-In berhasil dicatat pukul $formattedTime');
      } else {
        await todayRef.update(<String, dynamic>{
          'checkOutTime': formattedTime,
          'checkOutTimestamp': ServerValue.timestamp,
          'status': 'completed',
        });
        _showSnackBar('Check-Out berhasil dicatat pukul $formattedTime');
      }
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

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String todayKey = _activeDateKey;

    if (user == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Silakan login terlebih dahulu untuk melakukan absensi.'),
        ),
      );
    }

    final DatabaseReference companyRef =
        FirebaseDatabase.instance.ref('company_profile');
    final DatabaseReference todayRef = FirebaseDatabase.instance
        .ref('history_attendance/${user.uid}/$todayKey');

    // 1. Dengarkan pengaturan dari node `company_profile`
    return StreamBuilder<DatabaseEvent>(
      stream: companyRef.onValue,
      builder: (context, companySnapshot) {
        Map<dynamic, dynamic> companyData = <dynamic, dynamic>{};
        if (companySnapshot.hasData &&
            companySnapshot.data!.snapshot.value != null) {
          final Object? rawCompany = companySnapshot.data!.snapshot.value;
          if (rawCompany is Map<dynamic, dynamic>) {
            companyData = rawCompany;
          }
        }

        // Ambil pengaturan tombol absensi dari company_profile (default: true)
        final bool isAttendanceEnabled =
            companyData['isAttendanceEnabled'] is bool
                ? companyData['isAttendanceEnabled'] as bool
                : true;
        final String companyTitle =
            companyData['name']?.toString().trim().isNotEmpty == true
                ? companyData['name'].toString()
                : widget.title;

        // 2. Dengarkan data absensi hari ini (`todayKey`)
        return StreamBuilder<DatabaseEvent>(
          stream: todayRef.onValue,
          builder: (context, attendanceSnapshot) {
            Map<dynamic, dynamic> data = <dynamic, dynamic>{};
            if (attendanceSnapshot.hasData &&
                attendanceSnapshot.data!.snapshot.value != null) {
              final Object? raw = attendanceSnapshot.data!.snapshot.value;
              if (raw is Map<dynamic, dynamic>) {
                data = raw;
              }
            }

            final String? checkInTime = data['checkInTime']?.toString();
            final String? checkOutTime = data['checkOutTime']?.toString();

            final bool hasCheckedIn =
                checkInTime != null && checkInTime.trim().isNotEmpty;
            final bool hasCheckedOut =
                checkOutTime != null && checkOutTime.trim().isNotEmpty;

            final bool isCheckOutStep = hasCheckedIn && !hasCheckedOut;
            final bool isCompleted = hasCheckedIn && hasCheckedOut;

            final String statusTitle;
            final String statusSubtitle;
            final Color statusColor;
            final IconData statusIcon;
            final String buttonLabel;
            final IconData buttonIcon;
            final Color buttonColor;

            if (!isAttendanceEnabled) {
              statusTitle = 'Absensi Dinonaktifkan Perusahaan';
              statusSubtitle =
                  'Tombol absensi saat ini dinonaktifkan melalui pengaturan Company Profile.';
              statusColor = Colors.grey.shade700;
              statusIcon = Icons.lock_outline;
              buttonLabel = 'Absensi Nonaktif';
              buttonIcon = Icons.block;
              buttonColor = Colors.grey;
            } else if (isCompleted) {
              statusTitle = 'Absensi Hari Ini Selesai';
              statusSubtitle =
                  'Jejak masuk & pulang tersimpan. Otomatis reset pukul 00:00.';
              statusColor = Colors.green;
              statusIcon = Icons.check_circle;
              buttonLabel = 'Sudah Absen Pulang';
              buttonIcon = Icons.verified;
              buttonColor = Colors.green;
            } else if (isCheckOutStep) {
              statusTitle = 'Perhatian: Anda Belum Absen Pulang';
              statusSubtitle =
                  'Anda sudah Check-In pukul $checkInTime. Tekan tombol di bawah saat selesai kerja.';
              statusColor = Colors.deepOrange;
              statusIcon = Icons.warning_amber_rounded;
              buttonLabel = 'Check-Out Sekarang';
              buttonIcon = Icons.logout;
              buttonColor = Colors.deepOrange;
            } else {
              statusTitle = 'Belum Absen Masuk Hari Ini';
              statusSubtitle =
                  'Tekan tombol Check-In di bawah untuk merekam jam mulai kerja.';
              statusColor = kBrandPrimary;
              statusIcon = Icons.login;
              buttonLabel = 'Check-In Sekarang';
              buttonIcon = Icons.login;
              buttonColor = kBrandPrimary;
            }

            final bool isButtonDisabled =
                !isAttendanceEnabled || _isSaving || isCompleted;

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
                            companyTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
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
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  statusTitle,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  statusSubtitle,
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
                      onPressed: isButtonDisabled
                          ? null
                          : () => _handleAttendanceTap(
                                todayRef: todayRef,
                                isCheckOutStep: isCheckOutStep,
                                dateKey: todayKey,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(buttonIcon),
                      label: Text(
                        _isSaving ? 'Menyimpan...' : buttonLabel,
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
          },
        );
      },
    );
  }
}