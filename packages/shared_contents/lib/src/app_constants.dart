/// Berisi kumpulan nilai konstanta global yang digunakan bersama
/// di seluruh aplikasi dalam monorepo.
class AppConstants {
  // Mencegah kelas ini agar tidak dapat diinstansiasi
  AppConstants._();

  /// Nama aplikasi global
  static const String appName = 'Seller Sphere Ecosystem';

  /// Batas waktu timeout untuk koneksi jaringan (dalam detik)
  static const int apiTimeoutSeconds = 30;

  /// Pesan kesalahan umum yang sering digunakan
  static const String genericErrorMessage = 
      'Terjadi kesalahan pada sistem. Silakan coba beberapa saat lagi.';

  /// Regular Expression (Regex) standar untuk validasi format email
  static final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
}