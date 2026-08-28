import 'package:flutter/material.dart';

import 'package:shared_core/shared_core.dart';

class AppNavigation {
  static void goToSetting(BuildContext context) {
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