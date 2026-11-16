import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CrashReporterService {
  static final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('app_errors');

  /// Fungsi utama untuk menangkap semua error aplikasi secara otomatis.
  /// Panggil fungsi ini di dalam file main.dart pada masing-masing aplikasi anak.
  static Future<void> initialize({
    required String appName,
    required FutureOr<void> Function() runAppCallback,
  }) async {
    // 1. Menangkap error tampilan (Flutter Framework Errors)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      reportError(
        appName: appName,
        error: details.exception,
        stackTrace: details.stack,
        contextInfo: details.context?.toString() ?? 'Flutter UI Error',
      );
    };

    // 2. Menangkap error logika asinkron (Dart PlatformDispatcher Errors)
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      reportError(
        appName: appName,
        error: error,
        stackTrace: stack,
        contextInfo: 'Unhandled Async / Platform Error',
      );
      return true; // Mencegah aplikasi langsung force-close tanpa catatan
    };

    // Jalankan aplikasi utama
    await runAppCallback();
  }

  /// Fungsi untuk mengirim detail laporan error lengkap ke Firebase RTDB
  static Future<void> reportError({
    required String appName,
    required Object error,
    StackTrace? stackTrace,
    String contextInfo = 'General Error',
  }) async {
    try {
      // Ambil info versi aplikasi
      final packageInfo = await PackageInfo.fromPlatform();
      final String appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

      // Ambil info perangkat HP pengguna
      final String deviceDetails = await _getDeviceInfo();

      // Ambil info email pengguna yang sedang login (jika ada)
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final String userEmail = currentUser?.email ?? 'Belum Login / Guest';
      final String userId = currentUser?.uid ?? 'anonymous';

      // Buat ID unik berdasarkan waktu agar urut
      final String timestamp = DateTime.now().toIso8601String();
      final newErrorRef = _dbRef.push();

      await newErrorRef.set({
        'id': newErrorRef.key,
        'appName': appName, // Contoh: 'seller_sphere', 'admin_mikrotik'
        'appVersion': appVersion,
        'errorMessage': error.toString(),
        'stackTrace': stackTrace?.toString() ?? 'Tidak ada stack trace',
        'contextInfo': contextInfo,
        'deviceInfo': deviceDetails,
        'userEmail': userEmail,
        'userId': userId,
        'timestamp': timestamp,
        'status': 'open', // Status awal: 'open' (belum diperbaiki)
      });

      debugPrint('[$appName] Laporan error berhasil dikirim ke Matrix Sphere.');
    } catch (e) {
      // Jangan sampai proses pelaporan error malah menimbulkan error baru
      debugPrint('Gagal mengirim laporan error ke Firebase RTDB: $e');
    }
  }

  /// Helper untuk membaca tipe HP dan versi sistem operasi pengguna
  static Future<String> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (!kIsWeb && Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.manufacturer.toUpperCase()} ${androidInfo.model} (Android ${androidInfo.version.release}, SDK ${androidInfo.version.sdkInt})';
      } else if (!kIsWeb && Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return '${iosInfo.name} ${iosInfo.model} (iOS ${iosInfo.systemVersion})';
      } else if (!kIsWeb && Platform.isWindows) {
        final winInfo = await deviceInfo.windowsInfo;
        return 'Windows PC (${winInfo.computerName})';
      }
    } catch (_) {}
    return 'Perangkat Tidak Diketahui';
  }
}