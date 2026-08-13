/// Kelas untuk mengelola semua konstanta terkait API.
///
/// Menggunakan `String.fromEnvironment` untuk mengambil nilai yang diinjeksikan
/// pada saat kompilasi melalui flag `--dart-define`.
class ApiConstants {
  /// Kunci untuk Google Maps API.
  ///
  /// Nilai ini harus disediakan saat menjalankan atau membangun aplikasi.
  /// Contoh: flutter run --dart-define=GOOGLE_MAPS_API_KEY=AIza...
  static const String googleMapsApiKey = String.fromEnvironment(
    'AIzaSyCG_oXq8jpOoJeZ9uJ1gfeQ4kDVlTRHK4Q',
    defaultValue: '', // Default ke string kosong jika tidak disediakan
  );
}