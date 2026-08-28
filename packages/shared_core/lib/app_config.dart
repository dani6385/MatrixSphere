// packages/shared_core/lib/app_config.dart

import 'package:shared_core/shared_core.dart';

class AppConfig {
  // Variabel static untuk menyimpan tipe aplikasi yang sedang berjalan
  static late AppType currentApp;

  // Fungsi inisialisasi yang dipanggil di main.dart
  static void initialize(AppType type) {
    currentApp = type;
  }
}