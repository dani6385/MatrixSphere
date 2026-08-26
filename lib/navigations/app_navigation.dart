import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import 'package:shared_core/shared_core.dart';

class AppNavigation {
  static void goToSetting(BuildContext context, AppType appType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationScreen(
          currentApp: appType,
          initialPage: PageType.settings, extra: AppConfig.currentApp
        ),
      ),
    );
  }
}