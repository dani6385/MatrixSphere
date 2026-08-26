import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

class MainScreen extends StatelessWidget {
  /// Menentukan aplikasi mana yang sedang aktif saat ini
  final AppType currentApp;

  /// Menentukan halaman apa yang ingin ditampilkan saat ini
  final PageType currentPage;

  const MainScreen({
    super.key,
    required this.currentApp,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        centerTitle: true,
      ),
      body: Center(
        child: _buildPageContent(context),
      ),
    );
  }
  String _getAppBarTitle() {
    String appName = '';
    switch (currentApp) {
      case AppType.matrixSphere:
        appName = 'Matrix Sphere';
        break;
      case AppType.sellerSphere:
        appName = 'Seller Sphere';
        break;
      case AppType.shopSphere:
        appName = 'Shop Sphere';
        break;
      case AppType.adminMikrotik:
        appName = 'Admin Mikrotik';
        break;
      case AppType.clientConnectivity:
        appName = 'Client Connectivity';
        break;
    }

    return '$appName - ${currentPage.name.toUpperCase()}';
  }

  /// Fungsi untuk menampilkan widget halaman berdasarkan [currentPage]
  Widget _buildPageContent(BuildContext context) {
    switch (currentPage) {
      case PageType.login:
        return LoginContent(currentApp: currentApp);
      case PageType.userRegistration:
        return Text('Ini adalah Halaman Pendaftaran Pengguna Aplikasi aktif: $currentApp');
      case PageType.shopRegistration:
        return const Text('Ini adalah Halaman Pendaftaran Toko');
      case PageType.resetPassword:
        return const Text('Ini adalah Halaman Reset Kata Sandi');
      case PageType.home:
        return const Text('Ini adalah Halaman Utama (Home)');
      case PageType.attendance:
        return const Text('Ini adalah Halaman Absensi');
      case PageType.status:
        return const Text('Ini adalah Halaman Status');
      case PageType.account:
        return const Text('Ini adalah Halaman Akun');
      case PageType.other:
      default:
        return const Text('Halaman tidak ditemukan');
    }
  }
}