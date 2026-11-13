// app_navigation.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';


/// A helper class for navigating between screens.
/// This abstracts the GoRouter calls into more readable methods.
class AppNavigation {
  /// Goes back to the previous screen in the navigation stack.
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  /// Navigates to the Analytics screen.
  /// This uses `go` which is suitable for top-level navigation.
  static void goToAnalytics(BuildContext context) {
    context.go(AppRoutes.analytics);
  }

  static void goToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }

  static void pushToLogin(BuildContext context) {
    context.push(AppRoutes.login);
  }
  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }


  /// Navigates to the Profile screen.
  /// This uses `push` to stack the screen on top of the current one.
  static void pushToUserProfile(BuildContext context) {
    context.push(AppRoutes.userProfile);
  }

  static void pushToAnalytics(BuildContext context) {
    context.push(AppRoutes.analytics);
  }

  static void pushToApprovals(BuildContext context) {
    context.push(AppRoutes.approvals);
  }

  static void pushToAttendance(BuildContext context) {
    context.push(AppRoutes.attendance);
  }

}
