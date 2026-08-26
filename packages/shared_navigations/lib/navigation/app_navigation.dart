import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';
// Impor MainScreen dan Enum Anda jika diperlukan, atau rute halaman spesifik Anda
// import 'path/to/main_screen.dart';
// import 'path/to/app_type.dart';
// import 'path/to/page_type.dart';

class AppNavigation {
  /// Fungsi untuk berpindah ke Halaman Login secara dinamis
  static void goToLogin(BuildContext context, {required AppType appType}) {
    Navigator.pushNamed(context, '/login');

    // ATAU jika Anda menggunakan navigasi langsung berbasis Widget / MainScreen:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          currentApp: appType,
          currentPage: PageType.login,
        ),
      ),
    );
  }

  // Anda bisa menambahkan fungsi rute lainnya di sini dengan mudah, contoh:
  static void goToHome(BuildContext context, {required AppType appType}) {
    Navigator.pushNamed(context, '/home');
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          currentApp: appType,
          currentPage: PageType.home,
        ),
      ),
    );
  }
}
