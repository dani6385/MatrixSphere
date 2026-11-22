// lib/screens/Attendance/services/attendance_rtdb_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'attendance_location_service.dart';
import '../models/attendance_paths.dart';
import '../models/attendance_schedule_state.dart';

class AttendanceRtdbService {
  final FirebaseDatabase _db;

  AttendanceRtdbService({FirebaseDatabase? database})
    : _db = database ?? FirebaseDatabase.instance;

  Future<String> resolveUserName(User user) async {
    try {
      final DataSnapshot snap = await _db.ref('users/${user.uid}/name').get();
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

  /// Jika melewati pukul 00:00 dan hari kemarin ada Check-In namun lupa Check-Out,
  /// beri keterangan otomatis pada data hari kemarin lalu siapkan Check-In hari baru.
  Future<void> handleMidnightTransitionIfNeeded(DateTime now) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String yesterdayKey = AttendanceScheduleEvaluator.getDateKey(
      now.subtract(const Duration(days: 1)),
    );
    final String yesterdayPath = AttendancePaths.attendanceDay(
      uid: user.uid,
      dateKey: yesterdayKey,
    );
    final DatabaseReference yesterdayRef = _db.ref(yesterdayPath);

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

          await _db.ref('attendance/matrix/${user.uid}').update(
            <String, dynamic>{
              'status': 'Lupa Check-Out',
              'lastDate': yesterdayKey,
            },
          );
        }
      }
    } catch (_) {
      // Abaikan gangguan koneksi sementara saat cek latar belakang
    }
  }

  Future<int> recordCheckIn({
    required User user,
    required String userName,
    required DatabaseReference todayRef,
    required String dateKey,
    required String formattedTime,
    required int lateMinutes,
    AttendanceLocationData? location,
  }) async {
    final bool isLate = lateMinutes > 0;
    final DatabaseReference uidSummaryRef = _db.ref(
      'attendance/matrix/${user.uid}',
    );

    await todayRef.set(<String, dynamic>{
      'uid': user.uid,
      'name': userName,
      'date': dateKey,
      'checkInTime': formattedTime,
      'checkInTimestamp': ServerValue.timestamp,
      'checkInLocation': location?.toMap(),
      'checkOutTime': null,
      'checkOutLocation': null,
      'isLate': isLate,
      'lateMinutes': lateMinutes,
      'isOvertime': false,
      'forgotCheckOut': false,
      'status': 'Masuk',
      'statusCode': 'checked_in',
    });

    await uidSummaryRef.update(<String, dynamic>{
      'name': userName,
      'status': isLate ? 'Masuk (Terlambat)' : 'Masuk',
      'lastDate': dateKey,
    });

    return lateMinutes;
  }

  Future<void> recordCheckOut({
    required User user,
    required String userName,
    required DatabaseReference todayRef,
    required String dateKey,
    required String formattedTime,
    required bool isOvertime,
    AttendanceLocationData? location,
  }) async {
    final String currentStatus = isOvertime ? 'Selesai (Lembur)' : 'Selesai';
    final DatabaseReference uidSummaryRef = _db.ref(
      'attendance/matrix/${user.uid}',
    );

    await todayRef.update(<String, dynamic>{
      'name': userName,
      'checkOutTime': formattedTime,
      'checkOutTimestamp': ServerValue.timestamp,
      'checkOutLocation': location?.toMap(),
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
  }
}
