// lib/screens/Attendance/helpers/work_schedule_helper.dart

class WorkScheduleHelper {
  /// Default hari kerja: Senin (1) s.d. Jumat (5).
  /// Sabtu = 6, Minggu = 7.
  static const List<int> defaultWorkDays = <int>[1, 2, 3, 4, 5];

  static String toDateKey(DateTime date) {
    final String yyyy = date.year.toString().padLeft(4, '0');
    final String mm = date.month.toString().padLeft(2, '0');
    final String dd = date.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  /// Parsing format tanggal 'YYYY-MM-DD' atau 'DD-MM-YYYY' atau 'DD/MM/YYYY'.
  static DateTime? parseDate(dynamic raw) {
    if (raw == null) return null;
    final String s = raw.toString().trim();
    if (s.isEmpty) return null;

    // Format YYYY-MM-DD
    final RegExp isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$');
    final Match? mIso = isoMatch.firstMatch(s);
    if (mIso != null) {
      final int y = int.parse(mIso.group(1)!);
      final int m = int.parse(mIso.group(2)!);
      final int d = int.parse(mIso.group(3)!);
      return DateTime(y, m, d);
    }

    // Format DD-MM-YYYY atau DD/MM/YYYY (misal 22-11-2026 atau 22/11/2026)
    final RegExp idMatch = RegExp(r'^(\d{1,2})[-/](\d{1,2})[-/](\d{4})$');
    final Match? mId = idMatch.firstMatch(s);
    if (mId != null) {
      final int d = int.parse(mId.group(1)!);
      final int m = int.parse(mId.group(2)!);
      final int y = int.parse(mId.group(3)!);
      return DateTime(y, m, d);
    }

    return DateTime.tryParse(s);
  }

  /// Parsing daftar hari kerja dari RTDB (misal [1,2,3,4,5] atau "1,2,3,4,5").
  static List<int> parseWorkDays(dynamic raw) {
    if (raw is List) {
      final List<int> days = raw
          .map((e) => int.tryParse(e.toString().trim()))
          .whereType<int>()
          .where((d) => d >= 1 && d <= 7)
          .toSet()
          .toList()
        ..sort();
      if (days.isNotEmpty) return days;
    } else if (raw is String && raw.trim().isNotEmpty) {
      final List<int> days = raw
          .split(',')
          .map((e) => int.tryParse(e.trim()))
          .whereType<int>()
          .where((d) => d >= 1 && d <= 7)
          .toSet()
          .toList()
        ..sort();
      if (days.isNotEmpty) return days;
    }
    return defaultWorkDays;
  }

  /// Cek apakah `date` sudah berada pada atau setelah `startDate` (tanggal mulai kerja user).
  /// Jika `startDate` null, dianggap selalu berlaku.
  static bool isOnOrAfterStartDate(DateTime date, DateTime? startDate) {
    if (startDate == null) return true;
    final DateTime dOnly = DateTime(date.year, date.month, date.day);
    final DateTime sOnly =
        DateTime(startDate.year, startDate.month, startDate.day);
    return !dOnly.isBefore(sOnly);
  }

  /// Apakah hari tersebut termasuk hari kerja reguler (misal Senin–Jumat)?
  static bool isRegularWorkDay(
    DateTime date, {
    List<int> workDays = defaultWorkDays,
  }) {
    return workDays.contains(date.weekday);
  }

  /// Apakah absen pada `date` dihitung sebagai hari lembur (misal Sabtu atau Minggu)?
  static bool isWeekendOvertimeDay(
    DateTime date, {
    List<int> workDays = defaultWorkDays,
  }) {
    return !workDays.contains(date.weekday);
  }

  static String formatWorkDaysLabel(List<int> workDays) {
    const Map<int, String> names = <int, String>{
      1: 'Senin',
      2: 'Selasa',
      3: 'Rabu',
      4: 'Kamis',
      5: 'Jumat',
      6: 'Sabtu',
      7: 'Minggu',
    };
    final List<int> sorted = workDays.toSet().toList()..sort();
    if (sorted.length >= 2) {
      bool isConsecutive = true;
      for (int i = 1; i < sorted.length; i++) {
        if (sorted[i] != sorted[i - 1] + 1) {
          isConsecutive = false;
          break;
        }
      }
      if (isConsecutive) {
        return '${names[sorted.first]} - ${names[sorted.last]}';
      }
    }
    return sorted.map((d) => names[d] ?? '').where((s) => s.isNotEmpty).join(', ');
  }
}