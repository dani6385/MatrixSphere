/// File terpusat untuk mengelola semua API key dan variabel environment.
///
/// Menggunakan `String.fromEnvironment` memungkinkan kita untuk menyuntikkan nilai-nilai ini
/// saat kompilasi menggunakan flag `--dart-define`.
class ApiConstants {
  /// Kunci API untuk Google Maps.
  ///
  /// Diambil dari variabel environment 'GOOGLE_MAPS_API_KEY'.
  /// Contoh penggunaan:
  /// flutter run --dart-define=GOOGLE_MAPS_API_KEY=YOUR_SPECIFIC_KEY
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '', // Beri nilai default kosong
  );

  /// Kunci API untuk layanan upload gambar ImgBB.
  ///
  /// Diambil dari variabel environment 'IMGBB_API_KEY'.
  static const String imgbbApiKey = String.fromEnvironment(
    'IMGBB_API_KEY',
    defaultValue: '',
  );
}