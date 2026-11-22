// lib/screens/attendance/models/seller_attendance_paths.dart

/// Jalur Firebase Realtime Database khusus untuk **Seller Sphere**.
class AttendancePaths {
  static const String environmentKey = 'seller_sphere';

  /// `work_schedules/seller_sphere/{sellerId}`
  static String workSchedule({
    required String sellerId,
  }) {
    return 'work_schedules/seller_sphere/$sellerId';
  }

  /// Jalur riwayat absensi harian Seller Sphere di RTDB:
  /// `history_attendance/seller_sphere/{sellerId}/{uid}/{dateKey}`
  static String attendanceDay({
    required String sellerId,
    required String uid,
    required String dateKey,
  }) {
    return 'history_attendance/seller_sphere/$sellerId/$uid/$dateKey';
  }
}