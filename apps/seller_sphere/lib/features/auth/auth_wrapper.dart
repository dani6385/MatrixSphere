import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:shared_services/shared_services.dart';
import 'logins/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  final ShopService _shopService = ShopService();

  /// Memeriksa status toko pengguna (approved, pending, atau tidak ada).
  /// Fungsi ini sekarang memanggil implementasi terpusat dari ShopService.
  Future<ShopStatus> _getUserShopStatus() async {
    // Memanggil metode dari ShopService yang seharusnya berisi logika untuk
    // mengambil data dari database dan memeriksa field status.
    return _shopService.getUserShopStatus(_authService.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // Selama koneksi, tampilkan loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // Jika ada data pengguna (sudah login)
        if (snapshot.hasData) {
          // Cek status toko pengguna dan arahkan ke halaman yang sesuai
          return FutureBuilder<ShopStatus>(
            future: _getUserShopStatus(),
            builder: (context, shopSnapshot) {
              if (shopSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              final status = shopSnapshot.data ?? ShopStatus.none;
              // Arahkan berdasarkan status
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (status == ShopStatus.approved) {
                  // Jika toko disetujui, arahkan ke halaman utama.
                  context.go(AppRoutes.home);
                } else {
                  // Jika belum punya toko atau masih pending, arahkan ke halaman pendaftaran/tunggu
                  context.go(AppRoutes.shopRegistration);
                }
              });
              // Tampilkan loading indicator selagi navigasi diproses di frame berikutnya.
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            },
          );
        }

        // Jika tidak ada data (belum login), tampilkan halaman login
        return const LoginScreen(); // Asumsikan LoginScreen ada di sini
      },
    );
  }
}

/// PENTING:
/// File `AuthWrapper.dart` ini kemungkinan besar sudah tidak diperlukan (redundant).
/// File `d:\matrixsphere\apps\seller_sphere\lib\navigations\app_router.dart`
/// sudah menangani semua logika pengalihan (redirect) dengan lebih baik
/// menggunakan `refreshListenable` dan blok `redirect`.
///
/// Sebaiknya hapus `AuthWrapper` dari pohon widget Anda dan jadikan `GoRouter`
/// sebagai root widget di `MaterialApp.router`.
