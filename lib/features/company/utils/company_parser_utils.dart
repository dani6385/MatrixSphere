class CompanyParserUtils {
  CompanyParserUtils._();

  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim());
  }

  static int parseInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim()) ?? fallback;
  }

  static bool parseBool(dynamic value, {bool fallback = false}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is String) {
      final String lower = value.trim().toLowerCase();
      if (lower == 'true') return true;
      if (lower == 'false') return false;
    }
    return fallback;
  }

  static String formatPhotoType(String? rawType) {
    switch (rawType?.trim()) {
      case 'front_selfie':
        return 'Kamera Depan (Selfie)';
      case 'rear_site':
        return 'Kamera Belakang (Bukti Lokasi/Kerja)';
      case 'both':
        return 'Kamera Depan & Belakang';
      default:
        return 'Kamera Depan (Selfie)';
    }
  }
}