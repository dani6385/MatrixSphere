// lib/screens/admin/manage_users_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Halaman Kelola Jabatan Pekerja khusus untuk **Admin Matrix Sphere**.
/// Pengguna non-admin atau pengguna lingkungan lain tidak dapat mengubah jabatan.
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  /// Mengecek apakah nilai `role` termasuk hak akses Admin Matrix Sphere.
  static bool _hasMatrixAdminRole(dynamic rawRole) {
    final String normalized = (rawRole?.toString() ?? '').trim().toLowerCase();
    return normalized == 'admin' ||
        normalized == 'admin_matrix' ||
        normalized == 'matrix_admin';
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kelola Jabatan Pekerja')),
        body: const Center(
          child: Text('Silakan login terlebih dahulu.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Jabatan Pekerja'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: usersRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Belum ada data pekerja.'));
          }

          final Object? rawSnapshotValue = snapshot.data!.snapshot.value;
          if (rawSnapshotValue is! Map<dynamic, dynamic>) {
            return const Center(child: Text('Format data pekerja tidak valid.'));
          }

          // Cek role pengguna yang sedang login dari node `users/{currentUser.uid}`
          final dynamic currentUserRaw = rawSnapshotValue[currentUser.uid];
          final Map<dynamic, dynamic> currentUserMap =
              currentUserRaw is Map<dynamic, dynamic>
                  ? currentUserRaw
                  : <dynamic, dynamic>{};
          final bool isMatrixAdmin = _hasMatrixAdminRole(currentUserMap['role']);

          final List<MapEntry<dynamic, dynamic>> userEntries =
              rawSnapshotValue.entries.toList();

          return Column(
            children: [
              // Banner informasi status hak akses
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMatrixAdmin
                      ? Colors.blue.withValues(alpha: 0.08)
                      : Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isMatrixAdmin
                        ? Colors.blue.withValues(alpha: 0.35)
                        : Colors.orange.withValues(alpha: 0.45),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isMatrixAdmin
                          ? Icons.verified_user
                          : Icons.lock_outline,
                      color: isMatrixAdmin ? Colors.blue : Colors.deepOrange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isMatrixAdmin
                            ? 'Akses Admin Matrix Sphere aktif: Anda dapat mengubah jabatan pekerja.'
                            : 'Mode Lihat Saja: Hanya Admin Matrix Sphere yang dapat melakukan perubahan jabatan.',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isMatrixAdmin
                              ? Colors.blue.shade900
                              : Colors.deepOrange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Daftar pekerja
              Expanded(
                child: ListView.builder(
                  itemCount: userEntries.length,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                  itemBuilder: (context, index) {
                    final dynamic userId = userEntries[index].key;
                    final dynamic rawEntryValue = userEntries[index].value;
                    final Map<dynamic, dynamic> userData =
                        rawEntryValue is Map<dynamic, dynamic>
                            ? rawEntryValue
                            : <dynamic, dynamic>{};

                    final String name =
                        userData['name']?.toString() ?? 'Tanpa Nama';
                    final String email =
                        userData['email']?.toString() ?? 'Tidak ada email';
                    final String role =
                        userData['role']?.toString() ?? 'Pekerja / Karyawan';

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              isMatrixAdmin ? Colors.blue : Colors.grey,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('$email\nJabatan: $role'),
                        isThreeLine: true,
                        trailing: isMatrixAdmin
                            ? IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Ubah Jabatan',
                                onPressed: () {
                                  _showEditRoleDialog(
                                    context: context,
                                    uid: userId.toString(),
                                    currentName: name,
                                    currentRole: role,
                                    isMatrixAdmin: isMatrixAdmin,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 20,
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Fungsi dialog untuk mengubah jabatan pekerja (hanya jika `isMatrixAdmin == true`).
  void _showEditRoleDialog({
    required BuildContext context,
    required String uid,
    required String currentName,
    required String currentRole,
    required bool isMatrixAdmin,
  }) {
    if (!isMatrixAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Akses ditolak: hanya Admin Matrix Sphere yang dapat mengubah jabatan.',
          ),
        ),
      );
      return;
    }

    final TextEditingController roleController =
        TextEditingController(text: currentRole);

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Ubah Jabatan: $currentName'),
          content: TextField(
            controller: roleController,
            decoration: const InputDecoration(
              labelText: 'Nama Jabatan / Status Kerja',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String newRole = roleController.text.trim();
                if (newRole.isEmpty) return;

                try {
                  await FirebaseDatabase.instance
                      .ref('users/$uid')
                      .update(<String, dynamic>{
                    'role': newRole,
                  });

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Jabatan berhasil diperbarui!'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal memperbarui jabatan: $e'),
                        backgroundColor: Colors.red.shade700,
                      ),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}