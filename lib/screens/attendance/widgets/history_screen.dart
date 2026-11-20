// lib/screens/history/widgets/history_end_drawer.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

/// Drawer kanan (`endDrawer`) khusus untuk halaman Riwayat (`HistoryScreen`).
///
/// Menampilkan:
/// 1. Header profil pengguna aktif (nama, email, foto profil).
/// 2. Menu navigasi cepat terkait riwayat kerja & absensi.
class HistoryScreen extends StatelessWidget {
  /// Callback opsional saat pengguna memilih filter atau aksi khusus di HistoryScreen.
  final VoidCallback? onRefreshHistory;

  /// Path rute untuk kembali ke halaman absensi (sesuaikan dengan AppRoutes Anda).
  final String attendanceRoute;

  /// Path rute untuk membuka halaman riwayat lengkap (sesuaikan dengan AppRoutes Anda).
  final String historyRoute;

  const HistoryScreen({
    super.key,
    this.onRefreshHistory,
    this.attendanceRoute = '/attendance',
    this.historyRoute = '/history',
  });

  /// Menutup endDrawer secara aman sebelum melakukan navigasi.
  void _closeEndDrawer(BuildContext context) {
    final ScaffoldState? scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState != null && scaffoldState.hasEndDrawer) {
      scaffoldState.closeEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Referensi data profil pengguna di Firebase Realtime Database
    final DatabaseReference userRef = currentUser != null
        ? FirebaseDatabase.instance.ref('users/${currentUser.uid}')
        : FirebaseDatabase.instance.ref('users/guest');

    return Drawer(
      child: Column(
        children: [
          // 1. Header profil pengguna dari RTDB + fallback ke FirebaseAuth
          StreamBuilder<DatabaseEvent>(
            stream: userRef.onValue,
            builder: (context, snapshot) {
              Map<dynamic, dynamic> userData = <dynamic, dynamic>{};
              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                final Object? raw = snapshot.data!.snapshot.value;
                if (raw is Map<dynamic, dynamic>) {
                  userData = raw;
                }
              }

              final String displayName =
                  userData['name']?.toString().trim().isNotEmpty == true
                      ? userData['name'].toString()
                      : (currentUser?.displayName?.trim().isNotEmpty == true
                          ? currentUser!.displayName!
                          : 'Pengguna MatrixSphere');

              final String email = currentUser?.email ?? 'user@email.com';
              final String? photoUrl =
                  userData['photoUrl']?.toString().trim().isNotEmpty == true
                      ? userData['photoUrl'].toString()
                      : currentUser?.photoURL;

              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: kBrandPrimary),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      (photoUrl != null && photoUrl.isNotEmpty)
                          ? NetworkImage(photoUrl)
                          : null,
                  child: (photoUrl == null || photoUrl.isEmpty)
                      ? Icon(Icons.person, size: 38, color: kBrandPrimary)
                      : null,
                ),
                accountName: Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(email),
              );
            },
          ),

          // 2. Daftar menu di dalam endDrawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.history, color: kBrandPrimary),
                  title: const Text('Riwayat Kehadiran'),
                  subtitle: const Text('Lihat daftar Check-In & Check-Out'),
                  onTap: () {
                    _closeEndDrawer(context);
                    context.go(historyRoute);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: kBrandPrimary),
                  title: const Text('Halaman Absensi'),
                  subtitle: const Text('Kembali ke layar absensi kerja'),
                  onTap: () {
                    _closeEndDrawer(context);
                    context.go(attendanceRoute);
                  },
                ),
                if (onRefreshHistory != null) ...[
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.refresh, color: colorScheme.primary),
                    title: const Text('Muat Ulang Riwayat'),
                    subtitle: const Text('Perbarui data riwayat terbaru'),
                    onTap: () {
                      _closeEndDrawer(context);
                      onRefreshHistory!();
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}