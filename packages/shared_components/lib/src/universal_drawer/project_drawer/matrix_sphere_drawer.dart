import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

class MatrixSphereDrawer {
  static List<SideMenuItem> getDrawerItems(
      BuildContext context, PageType pageType, String currentRoute) {
    if (pageType == PageType.home) {
      return [
        SideMenuItem(
          title: 'Home / Beranda',
          icon: Icons.home,
          label: 'Kembali ke halaman utama dashboard.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
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
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Status Toko',
          icon: Icons.info_outline,
          label:
              'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Products / Produk',
          icon: Icons.shopping_bag,
          label:
              'Mengelola daftar produk, menambah barang baru, atau mengatur harga.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Orders / Pesanan',
          icon: Icons.receipt,
          label: 'Melihat dan memproses pesanan masuk dari pembeli.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Stok Barang / Inventaris',
          icon: Icons.inventory,
          label: 'Memantau ketersediaan stok barang secara mendetail.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Shopes / Pelanggan',
          icon: Icons.people,
          label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Google MAP',
          icon: Icons.map,
          label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Riwayat / Transaksi',
          icon: Icons.payment,
          label: 'Memeriksa riwayat pembayaran atau transaksi yang masuk.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Reports / Laporan',
          icon: Icons.bar_chart,
          label: 'Mengakses laporan penjualan harian, bulanan, atau tahunan.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
        SideMenuItem(
          title: 'Promotions / Promosi',
          icon: Icons.discount,
          label: 'Mengatur diskon, kupon, atau voucher toko.',
          route: AppRoutes.home,
          isSelected: currentRoute == AppRoutes.home,
          onTap: () => context.go(AppRoutes.home),
        ),
      ];
    }
    
    if (pageType == PageType.approvals) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
      ];
    }
    if (pageType == PageType.tasks) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
      ];
    }
    if (pageType == PageType.analytics) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
      ];
    }
    if (pageType == PageType.attendance) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
      ];
    }
    // Tambahkan kondisi halaman Matrix Sphere lainnya di sini...
    return [];
  }

  static List<SideMenuItem> getEndDrawerItems(
      BuildContext context, PageType pageType) {
    if (pageType == PageType.home) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
        SideMenuItem(
          title: 'Profile',
          icon: Icons.person,
          label: 'Melihat dan mengubah informasi profil akun toko.',
          route: '/user-profile',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Dark Mode',
          icon: Icons.dark_mode,
          label:
              'Mengubah tema tampilan aplikasi menjadi mode gelap atau terang.',
          route: '',
          onTap: () {
            // Aksi mengubah tema
          },
        ),
        SideMenuItem(
          title: 'Notifications',
          icon: Icons.notifications_active,
          label: 'Mengatur pemberitahuan pesanan masuk dan pesan pembeli.',
          route: '',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          label: 'Mengatur preferensi dasar aplikasi secara keseluruhan.',
          route: '/setting',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Security',
          icon: Icons.security,
          label: 'Mengatur kata sandi dan keamanan akun seller.',
          route: '',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Help',
          icon: Icons.help_outline,
          label: 'Membaca panduan penggunaan atau menghubungi pusat bantuan.',
          route: '',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'About',
          icon: Icons.info_outline,
          label: 'Melihat informasi versi dan pengembang aplikasi.',
          route: '',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Logout',
          icon: Icons.logout,
          label: 'Keluar dari sesi akun aktif pada aplikasi.',
          route: '',
          onTap: () {
            // Aksi keluar akun
          },
        ),
      ];
    }
    if (pageType == PageType.approvals) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
      ];
    }
    if (pageType == PageType.tasks) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
      ];
    }
    if (pageType == PageType.analytics) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
      ];
    }
    if (pageType == PageType.attendance) {
      return [
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          onTap: () => context.go('/setting'),
          route: '/setting',
          label: 'Pengaturan Aplikasi',
        ),
      ];
    }
    return [];
  }
}
