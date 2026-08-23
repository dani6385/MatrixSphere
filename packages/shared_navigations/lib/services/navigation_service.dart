import 'package:flutter/material.dart';

class NavigationService {
  // GlobalKey ini digunakan untuk melakukan navigasi tanpa BuildContext
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Fungsi untuk berpindah halaman baru
  static Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  // Fungsi untuk berpindah halaman dan menghapus halaman sebelumnya (misal setelah login)
  static Future<dynamic>? navigateAndRemoveUntil(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  // Fungsi untuk kembali ke halaman sebelumnya
  static void goBack() {
    return navigatorKey.currentState?.pop();
  }
}