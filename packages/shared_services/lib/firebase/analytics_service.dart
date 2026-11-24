//packages/shared_services/lib/firebase/analytics_service.dart

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Centralized service for Firebase Analytics across Matrix Sphere ecosystem.
class AnalyticsService {
  final FirebaseAnalytics _analytics;
  final FirebaseAuth _auth;

  AnalyticsService({
    FirebaseAnalytics? analytics,
    FirebaseAuth? auth,
  })  : _analytics = analytics ?? FirebaseAnalytics.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Navigator observer to plug into `GoRouter` (`observers: [analyticsService.observer]`).
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Enables or disables analytics data collection.
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (e) {
      _logDebug('setAnalyticsCollectionEnabled failed: $e');
    }
  }

  /// Sets user ID and optional user properties (pass `null` on logout).
  Future<void> setUser({
    String? uid,
    String? role,
    String? appVariant,
  }) async {
    try {
      final String? resolvedUid = uid ?? _auth.currentUser?.uid;
      await _analytics.setUserId(id: resolvedUid);

      if (role != null) {
        await _analytics.setUserProperty(name: 'user_role', value: role);
      }
      if (appVariant != null) {
        await _analytics.setUserProperty(name: 'app_variant', value: appVariant);
      }
    } catch (e) {
      _logDebug('setUser failed: $e');
    }
  }

  /// Clears user ID and user properties upon sign-out.
  Future<void> clearUser() async {
    try {
      await _analytics.setUserId(id: null);
      await _analytics.setUserProperty(name: 'user_role', value: null);
    } catch (e) {
      _logDebug('clearUser failed: $e');
    }
  }

  /// Logs a custom event with sanitized parameters.
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: _sanitizeName(name),
        parameters: parameters,
      );
    } catch (e) {
      _logDebug('logEvent($name) failed: $e');
    }
  }

  /// Logs a screen view event manually (useful for tabs inside `StatefulNavigationShell`).
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      _logDebug('logScreenView($screenName) failed: $e');
    }
  }

  // ===========================================================================
  // DOMAIN EVENT HELPERS FOR MATRIX SPHERE
  // ===========================================================================

  /// Logs user login event.
  Future<void> logLogin({String method = 'email'}) =>
      _analytics.logLogin(loginMethod: method);

  /// Logs attendance check-in or check-out event.
  Future<void> logAttendance({
    required String action, // 'check_in' | 'check_out'
    required String method, // 'qr' | 'face' | 'manual'
  }) =>
      logEvent(
        name: 'matrix_attendance',
        parameters: {
          'action': action,
          'method': method,
        },
      );

  /// Logs approval action (e.g. approving/rejecting a shop or employee).
  Future<void> logApprovalAction({
    required String targetType,
    required String decision,
    required String targetId,
  }) =>
      logEvent(
        name: 'matrix_approval_action',
        parameters: {
          'target_type': targetType,
          'decision': decision,
          'target_id': targetId,
        },
      );

  /// Ensures event names follow Firebase Analytics naming rules (alphanumeric + underscore, <= 40 chars).
  String _sanitizeName(String raw) {
    final String cleaned = raw
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    return cleaned.length > 40 ? cleaned.substring(0, 40) : cleaned;
  }

  void _logDebug(String message) {
    if (kDebugMode) {
      debugPrint('[ANALYTICS] $message');
    }
  }
}

/// Global instance to use across the app.
final analyticsService = AnalyticsService();