// lib/screens/Attendance/widgets/attendance_action_card.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../models/attendance_paths.dart';

/// Kartu absensi 1 tombol (Check-In & Check-Out) khusus **Matrix Sphere**.
class AttendanceActionCard extends StatefulWidget {
  final String title;

  const AttendanceActionCard({super.key, this.title = 'Absensi Kerja'});

  @override
  State<AttendanceActionCard> createState() => _AttendanceActionCardState();
}

class _AttendanceActionCardState extends State<AttendanceActionCard> {
  bool _isSaving = false;
  late String _activeDateKey;
  Timer? _clockCheckTimer;

  @override
  void initState() {
    super.initState();
    _activeDateKey = _getDateKey(DateTime.now());
    _handleMidnightTransitionIfNeeded(DateTime.now());

    // Periksa waktu berjalan & pergantian hari setiap 15 detik
    _clockCheckTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (!mounted) return;
      final DateTime now = DateTime.now();
      final String latestKey = _getDateKey(now);
      if (latestKey != _activeDateKey) {
        _handleMidnightTransitionIfNeeded(now);
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

  String _getDateKey(DateTime dt) {
    final String yyyy = dt.year.toString().padLeft(4, '0');
    final String mm = dt.month.toString().padLeft(2, '0');
    final String dd = dt.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  String _formatTime(DateTime dt) {
    final String hh = dt.hour.toString().padLeft(2, '0');
    final String mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  DateTime? _parseTodayTime(String hhmm, DateTime reference) {
    final List<String> parts = hhmm.trim().split(':');
    if (parts.length != 2) return null;
    final int? hour = int.tryParse(parts[0]);
    final int? minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return DateTime(
      reference.year,
      reference.month,
      reference.day,
      hour,
      minute,
    );
  }

  Future<String> _resolveUserName(User user) async {
    try {
      final DataSnapshot snap = await FirebaseDatabase.instance
          .ref('users/${user.uid}/name')
          .get();
      final String? dbName = snap.value?.toString().trim();
      if (dbName != null && dbName.isNotEmpty) {
        return dbName;
      }
    } catch (_) {
      // Gunakan fallback jika gagal membaca node users
    }

    final String? authName = user.displayName?.trim();
    if (authName != null && authName.isNotEmpty) {
      return authName;
    }

    final String? email = user.email?.trim();
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }

    return 'Pengguna';
  }

  Future<bool?> _showOvertimeConfirmationDialog({
    required String workEndTime,
    required String closeTimeText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Absen Pulang'),
        content: Text(
          'Absen pulang dibuka pukul $workEndTime - $closeTimeText.\nApakah Anda melakukan lembur hari ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Tidak Lembur'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ya, Lembur'),
          ),
        ],
      ),
    );
  }

  /// Jika melewati pukul 00:00 dan hari kemarin ada Check-In namun lupa Check-Out,
  /// beri keterangan otomatis pada data hari kemarin lalu siapkan Check-In hari baru.
  Future<void> _handleMidnightTransitionIfNeeded(DateTime now) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String yesterdayKey = _getDateKey(
      now.subtract(const Duration(days: 1)),
    );
    final String yesterdayPath = AttendancePaths.attendanceDay(
      uid: user.uid,
      dateKey: yesterdayKey,
    );
    final DatabaseReference yesterdayRef = FirebaseDatabase.instance.ref(
      yesterdayPath,
    );

    try {
      final DataSnapshot snap = await yesterdayRef.get();
      if (snap.exists && snap.value is Map<dynamic, dynamic>) {
        final Map<dynamic, dynamic> prevMap =
            snap.value as Map<dynamic, dynamic>;
        final String? checkIn = prevMap['checkInTime']?.toString();
        final String? checkOut = prevMap['checkOutTime']?.toString();

        final bool hadCheckIn = checkIn != null && checkIn.trim().isNotEmpty;
        final bool hadCheckOut = checkOut != null && checkOut.trim().isNotEmpty;

        if (hadCheckIn && !hadCheckOut) {
          final String existingNote = prevMap['note']?.toString().trim() ?? '';
          const String forgotNote =
              'Lupa Check-Out (otomatis di-reset pukul 00:00 untuk hari baru)';
          final String combinedNote = existingNote.isEmpty
              ? forgotNote
              : '$existingNote • $forgotNote';

          await yesterdayRef.update(<String, dynamic>{
            'note': combinedNote,
            'forgotCheckOut': true,
            'status': 'Lupa Check-Out',
            'statusCode': 'forgot_checkout_reset',
          });

          await FirebaseDatabase.instance
              .ref('attendance/matrix/${user.uid}')
              .update(<String, dynamic>{
                'status': 'Lupa Check-Out',
                'lastDate': yesterdayKey,
              });
        }
      }
    } catch (_) {
      // Abaikan gangguan koneksi sementara saat cek latar belakang
    }
  }

  Future<void> _handleAttendanceTap({
    required User user,
    required DatabaseReference todayRef,
    required bool isCheckOutStep,
    required String dateKey,
    required String workEndTime,
    required String closeTimeText,
  }) async {
    if (_isSaving) return;

    bool isOvertime = false;
    if (isCheckOutStep) {
      final bool? confirmedOvertime = await _showOvertimeConfirmationDialog(
        workEndTime: workEndTime,
        closeTimeText: closeTimeText,
      );
      if (confirmedOvertime == null) return;
      isOvertime = confirmedOvertime;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final DateTime now = DateTime.now();
      final String formattedTime = _formatTime(now);
      final String userName = await _resolveUserName(user);
      final DatabaseReference uidSummaryRef = FirebaseDatabase.instance.ref(
        'attendance/matrix/${user.uid}',
      );

      if (!isCheckOutStep) {
        const String currentStatus = 'Masuk';
        await todayRef.set(<String, dynamic>{
          'uid': user.uid,
          'name': userName,
          'date': dateKey,
          'checkInTime': formattedTime,
          'checkInTimestamp': ServerValue.timestamp,
          'checkOutTime': null,
          'isOvertime': false,
          'forgotCheckOut': false,
          'status': currentStatus,
          'statusCode': 'checked_in',
        });

        await uidSummaryRef.update(<String, dynamic>{
          'name': userName,
          'status': currentStatus,
          'lastDate': dateKey,
        });

        _showSnackBar('Check-In berhasil dicatat pukul $formattedTime');
      } else {
        final String currentStatus = isOvertime
            ? 'Selesai (Lembur)'
            : 'Selesai';
        await todayRef.update(<String, dynamic>{
          'name': userName,
          'checkOutTime': formattedTime,
          'checkOutTimestamp': ServerValue.timestamp,
          'isOvertime': isOvertime,
          'forgotCheckOut': false,
          'status': currentStatus,
          'statusCode': 'completed',
        });

        await uidSummaryRef.update(<String, dynamic>{
          'name': userName,
          'status': currentStatus,
          'lastDate': dateKey,
        });

        _showSnackBar(
          isOvertime
              ? 'Check-Out (Lembur) berhasil dicatat pukul $formattedTime'
              : 'Check-Out berhasil dicatat pukul $formattedTime',
        );
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
      builder: (context, scheduleSnapshot) {
        Map<dynamic, dynamic> companyData = <dynamic, dynamic>{};
        if (scheduleSnapshot.hasData &&
            scheduleSnapshot.data!.snapshot.value != null &&
            scheduleSnapshot.data!.snapshot.value is Map<dynamic, dynamic>) {
          companyData =
              scheduleSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        }
        return StreamBuilder<DatabaseEvent>(
          stream: legacyScheduleRef.onValue,
          builder: (context, scheduleSnapshot) {
            Map<dynamic, dynamic> scheduleData = <dynamic, dynamic>{};
            if (scheduleSnapshot.hasData &&
                scheduleSnapshot.data!.snapshot.value != null &&
                scheduleSnapshot.data!.snapshot.value
                    is Map<dynamic, dynamic>) {
              scheduleData =
                  scheduleSnapshot.data!.snapshot.value
                      as Map<dynamic, dynamic>;
            }

            final bool isAttendanceEnabled =
                companyData['isAttendanceEnabled'] is bool
                ? companyData['isAttendanceEnabled'] as bool
                : (scheduleData['isAttendanceEnabled'] is bool
                      ? scheduleData['isAttendanceEnabled'] as bool
                      : true);
            final String rawStart =
                companyData['matrixSphereWorkStart']
                        ?.toString()
                        .trim()
                        .isNotEmpty ==
                    true
                ? companyData['matrixSphereWorkStart'].toString().trim()
                : (scheduleData['workStartTime']
                              ?.toString()
                              .trim()
                              .isNotEmpty ==
                          true
                      ? scheduleData['workStartTime'].toString().trim()
                      : '08:00');
            final String rawEnd =
                companyData['matrixSphereWorkEnd']
                        ?.toString()
                        .trim()
                        .isNotEmpty ==
                    true
                ? companyData['matrixSphereWorkEnd'].toString().trim()
                : (scheduleData['workEndTime']?.toString().trim().isNotEmpty ==
                          true
                      ? scheduleData['workEndTime'].toString().trim()
                      : '17:00');
            final String workStartTime = rawStart;
            final String workEndTime = rawEnd;

            return StreamBuilder<DatabaseEvent>(
              stream: todayRef.onValue,
              builder: (context, attendanceSnapshot) {
                Map<dynamic, dynamic> data = <dynamic, dynamic>{};
                if (attendanceSnapshot.hasData &&
                    attendanceSnapshot.data!.snapshot.value != null &&
                    attendanceSnapshot.data!.snapshot.value
                        is Map<dynamic, dynamic>) {
                  data =
                      attendanceSnapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;
                }

                final String? checkInTime = data['checkInTime']?.toString();
                final String? checkOutTime = data['checkOutTime']?.toString();
                final String? recordedStatus = data['status']?.toString();

                final bool hasCheckedIn =
                    checkInTime != null && checkInTime.trim().isNotEmpty;
                final bool hasCheckedOut =
                    checkOutTime != null && checkOutTime.trim().isNotEmpty;

                final bool isCheckOutStep = hasCheckedIn && !hasCheckedOut;
                final bool isCompleted = hasCheckedIn && hasCheckedOut;

                // Perhitungan jendela waktu Check-In dan Check-Out
                final DateTime now = DateTime.now();
                final DateTime? startDt = _parseTodayTime(workStartTime, now);
                final DateTime? endDt = _parseTodayTime(workEndTime, now);

                // Check-In aktif mulai 1 jam sebelum jam mulai kerja (misal 08:00 -> 07:00)
                final DateTime? checkInOpenAt = startDt?.subtract(
                  const Duration(minutes: 60),
                );
                final String checkInOpenText = checkInOpenAt != null
                    ? _formatTime(checkInOpenAt)
                    : workStartTime;
                final bool isWithinCheckInWindow =
                    checkInOpenAt != null && !now.isBefore(checkInOpenAt);

                // Check-Out aktif TEPAT saat jam selesai kerja hingga +1 jam (misal 17:00 - 18:00)
                final DateTime? checkOutOpenAt = endDt;
                final DateTime? checkOutCloseAt = endDt?.add(
                  const Duration(minutes: 60),
                );
                final String checkOutCloseText = checkOutCloseAt != null
                    ? _formatTime(checkOutCloseAt)
                    : workEndTime;
                final bool isWithinCheckOutWindow =
                    checkOutOpenAt != null &&
                    checkOutCloseAt != null &&
                    !now.isBefore(checkOutOpenAt) &&
                    !now.isAfter(checkOutCloseAt);

                final String statusTitle;
                final String statusSubtitle;
                final Color statusColor;
                final IconData statusIcon;
                final String buttonLabel;
                final IconData buttonIcon;
                final Color buttonColor;
                final bool isButtonDisabled;

                if (!isAttendanceEnabled) {
                  statusTitle = 'Absensi $envLabel Sedang Dinonaktifkan';
                  statusSubtitle =
                      'Jam kerja terdaftar: $workStartTime - $workEndTime.';
                  statusColor = Colors.grey.shade700;
                  statusIcon = Icons.lock_outline;
                  buttonLabel = 'Absensi Nonaktif';
                  buttonIcon = Icons.block;
                  buttonColor = Colors.grey;
                  isButtonDisabled = true;
                } else if (isCompleted) {
                  statusTitle =
                      'Absensi Hari Ini ${recordedStatus ?? "Selesai"}';
                  statusSubtitle =
                      'Jam kerja $workStartTime - $workEndTime. Reset otomatis pukul 00:00.';
                  statusColor = Colors.green;
                  statusIcon = Icons.check_circle;
                  buttonLabel = 'Sudah Absen Pulang';
                  buttonIcon = Icons.verified;
                  buttonColor = Colors.green;
                  isButtonDisabled = true;
                } else if (isCheckOutStep) {
                  if (!isWithinCheckOutWindow) {
                    statusTitle = 'Belum Waktunya Absen Pulang';
                    statusSubtitle =
                        'Masuk pukul $checkInTime. Tombol Check-Out aktif pukul $workEndTime - $checkOutCloseText.';
                    statusColor = Colors.grey.shade700;
                    statusIcon = Icons.schedule;
                    buttonLabel = 'Check-Out Aktif Pukul $workEndTime';
                    buttonIcon = Icons.lock_clock;
                    buttonColor = Colors.grey;
                    isButtonDisabled = true;
                  } else {
                    statusTitle = 'Waktunya Absen Pulang (Check-Out)';
                    statusSubtitle =
                        'Masuk pukul $checkInTime. Absen pulang dibuka pukul $workEndTime - $checkOutCloseText.';
                    statusColor = Colors.deepOrange;
                    statusIcon = Icons.logout;
                    buttonLabel = 'Check-Out Sekarang';
                    buttonIcon = Icons.logout;
                    buttonColor = Colors.deepOrange;
                    isButtonDisabled = _isSaving;
                  }
                } else {
                  if (!isWithinCheckInWindow) {
                    statusTitle = 'Absen Masuk Belum Dibuka';
                    statusSubtitle =
                        'Jam kerja $workStartTime - $workEndTime. Check-In dibuka mulai pukul $checkInOpenText.';
                    statusColor = Colors.grey.shade700;
                    statusIcon = Icons.schedule;
                    buttonLabel = 'Check-In Dibuka Pukul $checkInOpenText';
                    buttonIcon = Icons.lock_clock;
                    buttonColor = Colors.grey;
                    isButtonDisabled = true;
                  } else {
                    statusTitle = 'Belum Absen Masuk Hari Ini';
                    statusSubtitle =
                        'Jam kerja $workStartTime - $workEndTime. Check-In dibuka sejak pukul $checkInOpenText.';
                    statusColor = kBrandPrimary;
                    statusIcon = Icons.login;
                    buttonLabel = 'Check-In Sekarang';
                    buttonIcon = Icons.login;
                    buttonColor = kBrandPrimary;
                    isButtonDisabled = _isSaving;
                  }
                }

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
                                '${widget.title} • $envLabel',
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
                                  user: user,
                                  todayRef: todayRef,
                                  isCheckOutStep: isCheckOutStep,
                                  dateKey: todayKey,
                                  workEndTime: workEndTime,
                                  closeTimeText: checkOutCloseText,
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
      },
    );
  }
}
