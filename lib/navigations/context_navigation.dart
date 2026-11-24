import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

extension AppNavigationContextX on BuildContext {
  void goToHome() {
    go(AppRoutes.home);
  }
  void goToUserProfile() {
    push(AppRoutes.userProfile);
  }
}