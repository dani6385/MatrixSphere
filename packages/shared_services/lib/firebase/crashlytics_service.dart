//packages/shared_services/lib/firebase/crashlytics_service.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized service for Firebase Crashlytics across Matrix Sphere ecosystem.
class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics;
  final FirebaseAuth _auth;

  CrashlyticsService({
    FirebaseCrashlytics? crashlytics,
    FirebaseAuth? auth,
  })  : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Initializes Crashlytics collection and attaches global Flutter & async error handlers.
  /// Call this in `main()` right after `Firebase.initializeApp()`.
  Future<void> initialize({bool enableInDebug = false}) async {
    if (kIsWeb) return;

    final bool shouldCollect = enableInDebug || !kDebugMode;
    await _crashlytics.setCrashlyticsCollectionEnabled(shouldCollect);

    // Tangkap error sinkron Flutter framework
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
      if (shouldCollect) {
        _crashlytics.recordFlutterFatalError(details);
      }
    };

    // Tangkap error asinkron di luar Flutter widget tree
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      if (shouldCollect) {
        _crashlytics.recordError(error, stack, fatal: true);
      }
      return true;
    };

    // Sinkronkan UID jika user sudah login saat aplikasi dimulai
    final String? uid = _auth.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      await setUserIdentifier(uid);
    }
  }

  /// Sets user identifier in Crashlytics reports (pass empty string on logout).
  Future<void> setUserIdentifier(String uid) async {
    if (kIsWeb) return;
    try {
      await _crashlytics.setUserIdentifier(uid);
    } catch (e) {
      _logDebug('setUserIdentifier failed: $e');
    }
  }

  /// Sets a custom key-value pair for crash diagnostics (e.g. `app_name`, `role`).
  Future<void> setCustomKey(String key, Object value) async {
    if (kIsWeb) return;
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      _logDebug('setCustomKey($key) failed: $e');
    }
  }

  /// Adds a breadcrumb message to the next Crashlytics report.
  Future<void> log(String message) async {
    if (kIsWeb) return;
    try {
      await _crashlytics.log(message);
    } catch (e) {
      _logDebug('log failed: $e');
    }
  }

  /// Records a non-fatal (or fatal) caught exception.
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
    Iterable<Object> information = const [],
  }) async {
    _logDebug('recordError(${reason ?? error}): $error');
    if (kIsWeb) return;

    try {
      await _crashlytics.recordError(
        error,
        stack ?? StackTrace.current,
        reason: reason,
        fatal: fatal,
        information: information,
      );
    } catch (e) {
      _logDebug('Failed to send error to Crashlytics: $e');
    }
  }

  /// Forces a test crash (use only in debug/staging verification).
  void testCrash() {
    if (!kIsWeb) {
      _crashlytics.crash();
    }
  }

  void _logDebug(String message) {
    if (kDebugMode) {
      debugPrint('[CRASHLYTICS] $message');
    }
  }
}

/// Global instance to use across the app.
final crashlyticsService = CrashlyticsService();