// lib/screens/approval_screen.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'widgets/approval_appbar.dart';
import 'package:shared_ui/shared_ui.dart';
import 'widgets/app_drawer.dart';
import 'widgets/app_end_drawer.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(
    'approval',
  );

  @override
  Widget build(BuildContext context) {
    final DatabaseReference _ = FirebaseDatabase.instance.ref().child(
      'approval',
    );
    return Scaffold(
      appBar: ApprovalAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getDrawerSideMenuItems(context, currentRoute);
        },
        header: const UserAccountsDrawerHeader(
          accountName: Text('Matrix Sphere'),
          accountEmail: Text('admin@matrixsphere.id'),
          currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apps, color: Colors.white, size: 36),
                  SizedBox(height: 12),
                  Text(
                    'Menu Aplikasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SharedProjectDrawer(
              menuBuilder: (context, currentRoute) {
                return getEndDrawerSideMenuItems(context, currentRoute);
              },
              header: const UserAccountsDrawerHeader(
                accountName: Text('Matrix Sphere'),
                accountEmail: Text('admin@matrixsphere.id'),
                currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
              ),
            ),
          ],
        ),
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
