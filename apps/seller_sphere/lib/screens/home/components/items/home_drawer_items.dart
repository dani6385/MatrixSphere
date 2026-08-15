// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
//import 'package:seller_sphere/navigations/app_extractor.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu yang kini ditambah properti 'label'
class DrawerItemData {
  final String title;
  final IconData icon;
  final String label; // Properti baru untuk menyimpan keterangan fungsi

  final VoidCallback? onTap;

  DrawerItemData({
    required this.title,
    required this.icon,
    required this.label,
    this.onTap,
  });
}

// Daftar seluruh item menu drawer dengan penambahan label fungsi
List<DrawerItemData> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    DrawerItemData(
      title: 'Home / Beranda',
      icon: Icons.home,
      label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Simulasi',
      icon: Icons.dashboard,
      label:
          'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Status Toko',
      icon: Icons.info_outline,
      label:
          'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Products / Produk',
      icon: Icons.shopping_bag,
      label:
          'Mengelola daftar produk, menambah barang baru, atau mengatur harga.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Orders / Pesanan',
      icon: Icons.receipt,
      label: 'Melihat dan memproses pesanan masuk dari pembeli.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Stok Barang / Inventaris',
      icon: Icons.inventory,
      label: 'Memantau ketersediaan stok barang secara mendetail.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Shopes / Pelanggan',
      icon: Icons.people,
      label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Google MAP',
      icon: Icons.map,
      label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Riwayat / Transaksi',
      icon: Icons.payment,
      label: 'Memeriksa riwayat pembayaran atau transaksi yang masuk.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Reports / Laporan',
      icon: Icons.bar_chart,
      label: 'Mengakses laporan penjualan harian, bulanan, atau tahunan.',
      onTap: () {},
    ),
    DrawerItemData(
      title: 'Promotions / Promosi',
      icon: Icons.discount,
      label: 'Mengatur diskon, kupon, atau voucher toko.',
      onTap: () {},
    ),
  ];
}
