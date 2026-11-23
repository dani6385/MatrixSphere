// lib/screens/Attendance_screen.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/screens/attendance/widgets/app_drawer.dart';
import 'package:matrix_sphere/screens/attendance/widgets/app_enddrawer.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:matrix_sphere/screens/attendance/widgets/attendance_appbar.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matrix_sphere/features/company/models/company_profile_model.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Referensi database untuk mendengarkan perubahan data profil pengguna secara real-time
    final DatabaseReference userRef = currentUser != null
        ? FirebaseDatabase.instance.ref('users/${currentUser.uid}')
        : FirebaseDatabase.instance.ref('dummy');
    final DatabaseReference companyRef = FirebaseDatabase.instance.ref(
      'company_profile',
    );

    return Scaffold(
      appBar: const AttendanceAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: StreamBuilder<DatabaseEvent>(
        stream: companyRef.onValue,
        builder: (context, snapshot) {
          Map<dynamic, dynamic>? rawCompanyData;
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            rawCompanyData =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          }

          // Gunakan CompanyProfileModel agar pemetaan data aman dan rapi
          final company = CompanyProfileModel.fromMap(rawCompanyData);

          return SharedProjectDrawer(
            menuBuilder: (context, currentRoute) {
              return getDrawerSideMenuItems(context, currentRoute);
            },
            header: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                // Tampilkan logo perusahaan dari ImgBB jika sudah diunggah
                backgroundImage: company.hasLogo
                    ? NetworkImage(company.logoUrl!)
                    : null,
                child: !company.hasLogo
                    ? const Icon(Icons.apartment, size: 40, color: Colors.blue)
                    : null,
              ),
              accountName: Text(company.name),
              accountEmail: Text(company.email),
              // Navigasi langsung ke halaman Profil Perusahaan saat header diketuk
              onDetailsPressed: () {
                AppNavigation.openCompanyProfile(
                  context,
                ); // Pindah ke halaman Company Profile
              },
            ),
          );
        },
      ),
      endDrawer: StreamBuilder<DatabaseEvent>(
        stream: userRef.onValue,
        builder: (context, snapshot) {
          Map<dynamic, dynamic> userData = {};
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            userData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          }

          // Ambil data dari RTDB dengan fallback ke FirebaseAuth
          final String displayName =
              userData['name']?.toString() ??
              currentUser?.displayName ??
              'Pengguna MatrixSphere';
          final String email = currentUser?.email ?? 'user@email.com';
          final String? photoUrl =
              userData['photoUrl']?.toString() ?? currentUser?.photoURL;

          return SharedProjectDrawer(
            header: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                // Jika photoUrl tersedia, tampilkan NetworkImage, jika tidak tampilkan ikon
                backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                    ? NetworkImage(photoUrl)
                    : null,
                child: (photoUrl == null || photoUrl.isEmpty)
                    ? const Icon(Icons.person, size: 40, color: Colors.blue)
                    : null,
              ),
              accountName: Text(displayName),
              accountEmail: Text(email),
              onDetailsPressed: () {
                // Arahkan ke halaman profile menggunakan ekstensi navigasi
                AppNavigation.openUserProfile(context);
              },
            ),
            menuBuilder: (context, currentRoute) {
              return getEndDrawerSideMenuItems(context, currentRoute);
            },
          );
        },
      ),
      body: //const AttendanceBody(),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ini adalah tampilan standar halaman utama (Attendance) Matrix Sphere. Silakan pilih menu di samping atau navigasi bawah untuk mulai menggunakan fitur lainnya.',
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
