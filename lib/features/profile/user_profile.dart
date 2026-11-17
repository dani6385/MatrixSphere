// lib/screens/profile/user_profile.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Sesi pengguna tidak ditemukan.')),
      );
    }

    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/${currentUser.uid}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'), // Kembali ke Home
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profil',
            // Navigasi ke sub-rute user-profile/edit
            onPressed: () => context.goToUserEditProfile(),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: userRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Ambil data tambahan dari RTDB jika sudah tersedia
          Map<dynamic, dynamic> userData = {};
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            userData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          }

          final String displayName = userData['name']?.toString() ??
              currentUser.displayName ??
              'Pengguna Matrix Sphere';
          final String email = currentUser.email ?? '-';
          final String phone = userData['phone']?.toString() ?? 'Belum diisi';
          final String role = userData['role']?.toString() ?? 'Administrator';
          final String address = userData['address']?.toString() ?? 'Belum diisi';
          final String? photoUrl =
              userData['photoUrl']?.toString() ?? currentUser.photoURL;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 1. Bagian Foto Profil (Avatar jika belum upload, NetworkImage jika sudah)
                CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                      ? NetworkImage(photoUrl)
                      : null,
                  child: (photoUrl == null || photoUrl.isEmpty)
                      ? const Icon(Icons.person, size: 60, color: Colors.blue)
                      : null,
                ),
                const SizedBox(height: 16),

                // Nama dan Email
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // 2. Kartu Informasi Data Pribadi
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildProfileTile(
                          icon: Icons.badge,
                          label: 'Jabatan / Role',
                          value: role,
                        ),
                        const Divider(),
                        _buildProfileTile(
                          icon: Icons.phone,
                          label: 'Nomor HP / WhatsApp',
                          value: phone,
                        ),
                        const Divider(),
                        _buildProfileTile(
                          icon: Icons.location_on,
                          label: 'Alamat',
                          value: address,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Tombol Menuju Halaman Edit Profil
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Ubah Data Profil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => context.goToUserEditProfile(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade50,
        child: Icon(icon, color: Colors.blue, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}