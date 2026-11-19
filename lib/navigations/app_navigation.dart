import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

class AppNavigation {
  // Mencegah instansiasi kelas karena seluruh metode bersifat static
  AppNavigation._();

  // ===========================================================================
  // 1. NAVIGASI DASAR (BACK)
  // ===========================================================================

  /// Kembali ke halaman sebelumnya jika memungkinkan; jika tidak ada riwayat,
  /// arahkan dengan aman ke halaman Home.
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  // ===========================================================================
  // 2. AUTENTIKASI (AUTH)
  // ===========================================================================

  static void goToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }

  static void goToLoginOption(BuildContext context) {
    context.go(AppRoutes.loginOption);
  }

  static void openForgotPassword(BuildContext context) {
    context.push(AppRoutes.forgotPassword);
  }

  static void openUserRegistration(BuildContext context) {
    context.push(AppRoutes.userRegistration);
  }

  static void openShopRegistration(BuildContext context) {
    context.push(AppRoutes.shopRegistration);
  }

  static void goToVerifyEmail(BuildContext context) {
    context.go(AppRoutes.verifyEmail);
  }

  // ===========================================================================
  // 3. HALAMAN UTAMA & CABANG SHELL (MATRIX SPHERE)
  // ===========================================================================

  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  static void goToApprovals(BuildContext context) {
    context.go(AppRoutes.approvals);
  }

  static void goToAnalytics(BuildContext context) {
    context.go(AppRoutes.analytics);
  }

  static void goToTransactions(BuildContext context) {
    context.go(AppRoutes.transactions);
  }

  static void goToAttendance(BuildContext context) {
    context.go(AppRoutes.attendance);
  }

  // ===========================================================================
  // 4. PROFIL & EDIT PROFIL (FULLSCREEN OVER ROOT NAVIGATOR)
  // ===========================================================================

  static void openProfile(BuildContext context) {
    context.push(AppRoutes.profile);
  }

  static void openUserProfile(BuildContext context) {
    context.push(AppRoutes.userProfile);
  }

  static void openCompanyProfile(BuildContext context) {
    context.push(AppRoutes.companyProfile);
  }

  static void openShopProfile(BuildContext context) {
    context.push(AppRoutes.shopProfile);
  }

  static void openEditProfile(BuildContext context) {
    context.push(AppRoutes.editProfile);
  }

  static void openEditUserProfile(BuildContext context) {
    context.push(AppRoutes.editUserProfile);
  }

  static void openEditCompanyProfile(BuildContext context) {
    context.push(AppRoutes.editCompanyProfile);
  }

  static void openEditShopProfile(BuildContext context) {
    context.push(AppRoutes.editShopProfile);
  }

  // ===========================================================================
  // 5. PENGATURAN & FITUR UMUM
  // ===========================================================================

  /// Membuka halaman pengaturan (pengganti versi MaterialPageRoute lama).
  static void goToSetting(BuildContext context, {Object? extra}) {
    context.push(AppRoutes.settings, extra: extra);
  }

  static void openNotifications(BuildContext context) {
    context.push(AppRoutes.notifications);
  }

  static void openScanQr(BuildContext context) {
    context.push(AppRoutes.scanQr);
  }

  static void openScanFace(BuildContext context) {
    context.push(AppRoutes.scanFace);
  }
}