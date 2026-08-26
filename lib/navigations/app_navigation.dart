import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import 'package:shared_ui/shared_ui.dart';

class AppNavigation {
  static void goToSetting(BuildContext context, AppType appType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationScreen(
          currentApp: appType,
          initialPage: PageType.settings, // Memberitahu screen untuk buka hal. settings
        ),
      ),
    );
  }
}