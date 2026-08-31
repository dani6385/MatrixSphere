// lib/screens/approval_screen.dart

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
  final Map<String, dynamic> _approvalData = {
    "toko_andika": {"nama": "andika", "status": "waiting"},
  };

  @override
  Widget build(BuildContext context) {
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
      body: ApprovalBody(
        approvalData: _approvalData,
        onApprove: (shopKey, shopName) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Menyetujui $shopName')),
          );
        },
        onReject: (shopKey, shopName) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Menolak $shopName')),
          );
        },
      ),
    );
  }
}
