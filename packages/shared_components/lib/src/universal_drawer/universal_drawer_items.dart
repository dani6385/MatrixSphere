import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
// Asumsi AppRoutes ada di sini
import 'package:shared_navigations/shared_navigation.dart'; // Import AppRoutes
import 'package:shared_ui/shared_ui.dart';

/// Returns a list of `SideMenuItem` for the main drawer based on the feature.
List<SideMenuItem> getUniversalDrawerItems(
  BuildContext context, {
  required AppType appType,
  required PageType pageType,
  required String currentRoute,
}) {
  final Logger logger = Logger();

  // Logika untuk App: matrixSphere, Page: home
  if (appType == AppType.matrixSphere && pageType == PageType.home) {
    return [
      SideMenuItem(
        title: 'Home / Beranda',
        icon: Icons.home,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.home,
        isSelected: currentRoute == AppRoutes.home,
        onTap: () => context.go(AppRoutes.home),
      ),
    ];
  }
  if (appType == AppType.matrixSphere && pageType == PageType.approvals) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }
  if (appType == AppType.matrixSphere && pageType == PageType.tasks) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }
  if (appType == AppType.matrixSphere && pageType == PageType.analytics) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }
  if (appType == AppType.matrixSphere && pageType == PageType.attendance) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }
  // Logika untuk App: sellerSphere (berlaku untuk semua halaman di dalamnya)
  if (appType == AppType.sellerSphere && pageType == PageType.home) {
    // Logika untuk aplikasi Seller Sphere
    return [
      SideMenuItem(
        title: 'Home / Beranda',
        icon: Icons.home,
        label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
        route: AppRoutes.home,
        isSelected: currentRoute == AppRoutes.home,
        onTap: () => context.go(AppRoutes.home),
      ),
      SideMenuItem(
        title: 'Simulasi',
        icon: Icons.dashboard,
        label:
            'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
        onTap: () => logger.i('Simulasi tapped'),
        route: '',
      ),
      SideMenuItem(
        title: 'Status Toko',
        icon: Icons.info_outline,
        label:
            'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
        onTap: () => logger.i('Status Toko tapped'),
        route: '',
      ),
      SideMenuItem(
        title: 'Products / Produk',
        icon: Icons.shopping_bag,
        label:
            'Mengelola daftar produk, menambah barang baru, atau mengatur harga.',
        onTap: () => logger.i('Products tapped'),
        route: '',
      ),
      SideMenuItem(
        title: 'Orders / Pesanan',
        icon: Icons.receipt,
        label: 'Melihat dan memproses pesanan masuk dari pembeli.',
        onTap: () => logger.i('Orders tapped'),
        route: '',
      ),
      SideMenuItem(
        title: 'Stok Barang / Inventaris',
        icon: Icons.inventory,
        label: 'Memantau ketersediaan stok barang secara mendetail.',
        onTap: () => logger.i('Inventory tapped'),
        route: '',
      ),
      SideMenuItem(
        title: 'Customers / Pelanggan',
        icon: Icons.people,
        label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
        onTap: () => logger.i('Customers tapped'),
        route: '',
      ),
      SideMenuItem(
        title: 'Google MAP',
        icon: Icons.map,
        label: 'Melihat lokasi toko di peta.',
        onTap: () => logger.i('Google MAP tapped'),
        route: '',
      ),
      SideMenuItem(
        title: 'Riwayat / Transaksi',
        icon: Icons.payment,
        label: 'Memeriksa riwayat pembayaran atau transaksi yang masuk.',
        onTap: () => logger.i('Transactions tapped'),
        route: '',
      ),
      SideMenuItem(
        title: 'Reports / Laporan',
        icon: Icons.bar_chart,
        label: 'Mengakses laporan penjualan harian, bulanan, atau tahunan.',
        onTap: () => logger.i('Reports tapped'),
        route: '',
      ),
      SideMenuItem(
        title: 'Promotions / Promosi',
        icon: Icons.discount,
        label: 'Mengatur diskon, kupon, atau voucher toko.',
        onTap: () => logger.i('Promotions tapped'),
        route: '',
      ),
    ];
  }

  if (appType == AppType.sellerSphere && pageType == PageType.financial) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.sellerSphere && pageType == PageType.management) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.sellerSphere && pageType == PageType.seller) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.sellerSphere && pageType == PageType.attendance) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.home) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.feeds) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.searching) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.transactions) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.account) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        isSelected: currentRoute == AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }
  return []; // Default empty list
}

/// Returns a list of `SideMenuItem` for the end drawer (settings).
List<SideMenuItem> getUniversalEndDrawerItems(BuildContext context,
    {required AppType appType, required PageType pageType}) {
  final Logger logger = Logger();

  // Logika untuk membedakan item EndDrawer berdasarkan fitur.
  // Anda bisa mengisinya dengan item-item dari `home_end_drawer_items.dart`
  // dan `attendance_end_drawer_items.dart`.

  // Logika untuk App: matrixSphere, Page: home
  if (appType == AppType.matrixSphere && pageType == PageType.home) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        onTap: () =>
            context.go('/setting'), // Idealnya: context.go(AppRoutes.settings)
        route: '/setting',
        label: 'Pengaturan Aplikasi',
      ),
    ];
  }

  // Logika untuk App: sellerSphere (berlaku untuk semua halaman di dalamnya)
  if (appType == AppType.sellerSphere) {
    // Logika EndDrawer untuk aplikasi Seller Sphere
    return [
      SideMenuItem(
        title: 'Profile',
        icon: Icons.person,
        label: 'Melihat dan mengubah informasi profil akun toko.',
        route: '/user-profile',
        onTap: () => context.go('/user-profile'),
      ),
      SideMenuItem(
        title: 'Dark Mode',
        icon: Icons.dark_mode,
        label:
            'Mengubah tema tampilan aplikasi menjadi mode gelap atau terang.',
        route: '',
        onTap: () => logger.i('Dark Mode tapped'),
      ),
      SideMenuItem(
        title: 'Notifications',
        icon: Icons.notifications_active,
        label: 'Mengatur pemberitahuan pesanan masuk dan pesan pembeli.',
        route: '',
        onTap: () => logger.i('Notifications tapped'),
      ),
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Mengatur preferensi dasar aplikasi secara keseluruhan.',
        route: '/setting',
        onTap: () => context.go('/setting'),
      ),
      SideMenuItem(
        title: 'Security',
        icon: Icons.security,
        label: 'Mengatur kata sandi dan keamanan akun seller.',
        route: '',
        onTap: () => logger.i('Security tapped'),
      ),
      SideMenuItem(
        title: 'Help',
        icon: Icons.help_outline,
        label: 'Membaca panduan penggunaan atau menghubungi pusat bantuan.',
        route: '',
        onTap: () => logger.i('Help tapped'),
      ),
      SideMenuItem(
        title: 'About',
        icon: Icons.info_outline,
        label: 'Melihat informasi versi dan pengembang aplikasi.',
        route: '',
        onTap: () => logger.i('About tapped'),
      ),
    ];
  }

  if (appType == AppType.sellerSphere && pageType == PageType.financial) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.sellerSphere && pageType == PageType.management) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.sellerSphere && pageType == PageType.seller) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.sellerSphere && pageType == PageType.attendance) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.home) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.feeds) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.searching) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.transactions) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }

  if (appType == AppType.shopSphere && pageType == PageType.account) {
    return [
      SideMenuItem(
        title: 'Settings',
        icon: Icons.settings,
        label: 'Kembali ke halaman utama dashboard.',
        route: AppRoutes.settings,
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];
  }
  // Fallback default jika fitur tidak dikenali
  return [
    SideMenuItem(
      title: 'Logout',
      icon: Icons.logout,
      label: 'Keluar dari akun Anda.',
      onTap: () {
        logger.i('Logout action triggered');
      },
      route: '',
    ),
  ];
}
