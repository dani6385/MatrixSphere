// lib/screens/Attendance/models/attendance_paths.dart

/// Kelas pembantu untuk menyusun jalur Firebase Realtime Database secara konsisten
/// antara lingkungan **Matrix Sphere** dan **Seller Sphere** (per `sellerId` & `uid`).
class AttendancePaths {
  static const String matrixEnv = 'matrix_sphere';
  static const String sellerEnv = 'seller_sphere';

  /// Menormalkan kunci lingkungan menjadi `'seller_sphere'` atau `'matrix_sphere'`.
  static String normalizeEnvironment(String? environmentKey) {
    final String value = (environmentKey ?? '').trim();
    return value == sellerEnv ? sellerEnv : matrixEnv;
  }

  /// Menentukan `sellerId` efektif. Jika `sellerId` kosong, pakai `fallbackUid`.
  static String resolveSellerId({
    required String? sellerId,
    required String fallbackUid,
  }) {
    final String cleaned = (sellerId ?? '').trim();
    return cleaned.isNotEmpty ? cleaned : fallbackUid;
  }

  /// - Matrix Sphere : `work_schedules/matrix_sphere`
  static String workSchedule({
    required String environmentKey,
    required String uid,
    String? sellerId,
  }) {
    final String env = normalizeEnvironment(environmentKey);
    if (env == sellerEnv) {
      final String effectiveSellerId =
          resolveSellerId(sellerId: sellerId, fallbackUid: uid);
      return 'work_schedules/$sellerEnv/$effectiveSellerId';
    }
    return 'work_schedules/$matrixEnv';
  }

  /// Jalur riwayat absensi harian di RTDB:
  /// - Matrix Sphere : `history_attendance/matrix_sphere/{uid}/{dateKey}`
  /// - Seller Sphere : `history_attendance/seller_sphere/{sellerId}/{uid}/{dateKey}`
  static String attendanceDay({
    required String environmentKey,
    required String uid,
    required String dateKey,
    String? sellerId,
  }) {
    final String env = normalizeEnvironment(environmentKey);
    if (env == sellerEnv) {
      final String effectiveSellerId =
          resolveSellerId(sellerId: sellerId, fallbackUid: uid);
      return 'history_attendance/$sellerEnv/$effectiveSellerId/$uid/$dateKey';
    }
    return 'history_attendance/$matrixEnv/$uid/$dateKey';
  }
}