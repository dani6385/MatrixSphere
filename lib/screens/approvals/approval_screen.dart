// lib/screens/approval_screen.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'widgets/approval_appbar.dart';
import 'widgets/approval_body.dart'; // Impor body yang baru
import 'package:shared_components/shared_components.dart';
import 'widgets/drawer_items.dart';
import 'widgets/end_drawer_items.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('approvals');

  @override
  Widget build(BuildContext context) {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('approvals');
    return Scaffold(
      appBar: ApprovalAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.apps,
                    color: Colors.white,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  const Text(
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
                return getDrawerSideMenuItems(context, currentRoute);
              },
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.apps,
                    color: Colors.white,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  const Text(
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
            ),
          ],
        ),
      ),
      // Memanggil ApprovalBody yang sudah dipisahkan
      body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          // 1. Kondisi saat data masih dimuat (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Kondisi jika terjadi error atau data kosong
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(
              child: Text(
                'Tidak ada data persetujuan saat ini.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // 3. Mengambil dan mengubah data dari Firebase menjadi Map<String, dynamic>
          final rawData = snapshot.data!.snapshot.value;
          final Map<String, dynamic> approvalData = Map<String, dynamic>.from(rawData as Map);

          // 4. Masukkan data dinamis ke dalam ApprovalBody
          return ApprovalBody(
            approvalData: approvalData,
            onApprove: (shopKey, shopName) {
              // Logika aksi setuju ke database RTDB
              dbRef.child(shopKey).update({'status': 'approved'});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Menyetujui $shopName')),
              );
            },
            onReject: (shopKey, shopName) {
              // Logika aksi tolak ke database RTDB
              dbRef.child(shopKey).update({'status': 'rejected'});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Menolak $shopName')),
              );
            },
          );
        },
      ),
    );
  }
}