// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:matrix_sphere/screens/home/widgets/home_drawer_items.dart';
import 'package:matrix_sphere/screens/home/widgets/home_end_drawer_items.dart';
import 'package:shared_components/shared_components.dart';
import 'widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getDrawerSideMenuItems(context, currentRoute);
        },
      ),
      endDrawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getEndDrawerSideMenuItems(context, currentRoute);
        },
      ),
      // Menggunakan ListView sebagai body standar agar halaman bisa digulir
      body: //const HomeBody(),
      ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Kartu Sambutan Utama
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Selamat Datang!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ini adalah tampilan standar halaman utama (Home) Matrix Sphere. Silakan pilih menu di samping atau navigasi bawah untuk mulai menggunakan fitur lainnya.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Contoh Daftar Menu Pintasan Standar
          const Text(
            'Menu Cepat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.approval, color: Colors.blue),
            title: const Text('Persetujuan (Approval)'),
            subtitle: const Text('Kelola daftar persetujuan toko'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Tambahkan navigasi ke halaman approval jika diperlukan
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time, color: Colors.green),
            title: const Text('Absensi Kehadiran'),
            subtitle: const Text('Catat jam masuk dan pulang kerja'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Tambahkan navigasi ke halaman absensi jika diperlukan
            },
          ),
        ],
      ),
    );
  }
}