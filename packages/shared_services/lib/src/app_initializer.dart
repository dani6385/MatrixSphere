// packages/shared_services/lib/src/app_initializer.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class AppInitializer {
  static Future<void> initializeFirebase(FirebaseOptions options) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await Firebase.initializeApp(options: options);
      FlutterError.onError = crashlyticsService.recordFlutterFatalError;
      // ... (konfigurasi error lainnya)
    } catch (e, stack) {
      crashlyticsService.recordError(e, stack,
          reason: 'Failed to initialize Firebase');
    }
  }
}
