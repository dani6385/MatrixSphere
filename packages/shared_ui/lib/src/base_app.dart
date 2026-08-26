// packages/shared_ui/lib/src/base_app.dart
import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

class BaseApp extends StatelessWidget {
  final String title;
  final GoRouter routerConfig;
  final List<Widget>? providers; // Untuk Bloc/Provider spesifik
  final ThemeMode themeMode;

  const BaseApp({
    super.key,
    required this.title,
    required this.routerConfig,
    this.providers,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: routerConfig,
    );
  }
}