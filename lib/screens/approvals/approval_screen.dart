// lib/screens/approval_screen.dart

import 'package:flutter/material.dart';
import 'widgets/approval_appbar.dart';
import 'widgets/approval_body.dart'; // Impor body yang baru
import 'package:shared_components/shared_components.dart';
import 'widgets/drawer_items.dart';
import 'widgets/end_drawer_items.dart';
import 'package:shared_screens/shared_screens.dart';

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