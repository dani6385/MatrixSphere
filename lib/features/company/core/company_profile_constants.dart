class CompanyProfileConstants {
  CompanyProfileConstants._();

  // Admin & Path Firebase RTDB
  static const String permanentAdminUid = 'mjS1Y9Ll3JRQCMGSTK2oIBVIHT22';
  static const String companyProfilePath = 'company_profile';

  // Aturan absensi selalu wajib aktif (tidak di-toggle true/false oleh user)
  static const bool mandatoryAttendanceEnabled = true;
  static const bool mandatoryLocationRequired = true;
  static const bool mandatoryPhotoRequired = true;
  static const bool disallowOutsideRadius = false;
  static const String mandatoryPhotoType = 'front_selfie';

  // Nilai default waktu & toleransi
  static const String defaultWorkStart = '08:00';
  static const String defaultWorkEnd = '17:00';
  static const String defaultCheckoutTime = '16:00';
  static const String defaultWeekendStart = '08:00';
  static const String defaultWeekendEnd = '17:00';
  static const String defaultWeekdayOvertimeEnd = '21:00';

  // Nilai default radius & keterlambatan
  static const String defaultRadiusMeters = '100';
  static const int defaultGraceMinutes = 15;
  static const String defaultGraceMinutesStr = '15'; // Untuk TextEditingController

  // Nilai default teks jadwal & catatan lembur
  static const String defaultOvertimeScheduleText = 'Lembur sampai jam 7 malam';
  static const String defaultDecreeNote =
      'Dekrit lembur aktif: pekerja melaksanakan lembur setelah jam kerja atau hari Sabtu & Minggu.';
  static const String noOvertimeNote =
      'Tidak ada kewajiban lembur; pekerja pulang sesuai jadwal.';

  // Label hari (ISO weekday: 1 = Senin s/d 7 = Minggu)
  static const Map<int, String> dayLabels = <int, String>{
    1: 'Senin',
    2: 'Selasa',
    3: 'Rabu',
    4: 'Kamis',
    5: 'Jumat',
    6: 'Sabtu',
    7: 'Minggu',
  };
}