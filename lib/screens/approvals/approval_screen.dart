// lib/screens/approval_screen.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'widgets/approval_appbar.dart';
import 'package:shared_ui/shared_ui.dart';
import 'widgets/app_drawer.dart';
import 'widgets/app_end_drawer.dart';
import 'widgets/approval_body.dart';

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
      body: const ApprovalBody(),
    );
  }
}
