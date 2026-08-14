import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:shared_services/auth/shop_status.enum.dart';
import 'package:shared_services/shared_services.dart' hide ShopService;

class AuthGuard {
  static final AuthService _authService = AuthService();
  static final ShopService _shopService = ShopService();

  static Future<String?> checkRedirect(
      BuildContext context, GoRouterState state) async {
    final bool isLoggedIn = _authService.isLoggedIn();
    final String currentPath = state.uri.path;

    final bool onAuthRoute = currentPath == AppRoutes.login ||
        currentPath == AppRoutes.userRegistration;

    // 1. Logika untuk pengguna yang belum login
    if (!isLoggedIn) {
      if (currentPath != '/' && !onAuthRoute) {
        return AppRoutes.login;
      }
      return null; 
    }

    // 2. Logika untuk pengguna yang sudah login (mencegah balik ke login/reg)
    if (onAuthRoute) {
      return AppRoutes.home;
    }

    // 3. Cek status toko untuk pengguna yang sudah login
    final String? shopStatusString =
        await _shopService.getCurrentShopId(_authService.currentUser);
    
    final ShopStatus? shopStatus = shopStatusString != null
        ? ShopStatus.values.firstWhereOrNull((e) => e.name == shopStatusString)
        : null;

    final bool hasApprovedShop = shopStatus == ShopStatus.approved;
    final bool onShopRegistrationRoute = currentPath == AppRoutes.shopRegistration;

    // Jika toko belum disetujui, arahkan ke registrasi toko
    if (!hasApprovedShop && !onShopRegistrationRoute) {
      return AppRoutes.shopRegistration;
    }

    // Jika toko sudah disetujui tapi masih di halaman registrasi, arahkan ke home
    if (hasApprovedShop && onShopRegistrationRoute) {
      return AppRoutes.home;
    }

    return null; // Tidak ada pengalihan
  }
}