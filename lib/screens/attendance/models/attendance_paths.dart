// lib/screens/attendance/models/matrix_attendance_paths.dart

/// Jalur Firebase Realtime Database khusus untuk **Matrix Sphere**.
class AttendancePaths {
  static const String environmentKey = 'matrix_sphere';

  /// `work_schedules/matrix_sphere`
  static String workSchedule() {
    return 'work_schedules/matrix_sphere';
  }

  /// Jalur riwayat absensi harian Matrix Sphere di RTDB:
  /// `attendance/matrix/{uid}/{dateKey}`
  static String attendanceDay({
    required String uid,
    required String dateKey,
  }) {
    return 'attendance/matrix/$uid/$dateKey';
  }
}