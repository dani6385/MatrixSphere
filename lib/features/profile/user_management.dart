// lib/screens/admin/user_management.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Halaman `UserManagement` (`user_management.dart`) untuk memberikan dan
/// mengubah jabatan karyawan pada lingkungan **Matrix Sphere**.
///
/// Hanya pengguna dengan peran Admin Matrix Sphere yang dapat melakukan
/// perubahan jabatan; pengguna lain berada pada mode lihat saja.
class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

  /// Daftar saran jabatan cepat agar admin lebih mudah memberikan jabatan.
  static const List<String> _suggestedRoles = <String>[
    'Karyawan',
    'Staff Operasional',
    'Supervisor',
    'Admin',
  ];

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
        appBar: AppBar(title: const Text('Kelola Jabatan Karyawan')),
        body: const Center(
          child: Text('Silakan login terlebih dahulu.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Jabatan Karyawan'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: usersRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Belum ada data karyawan.'));
          }

          final Object? rawSnapshotValue = snapshot.data!.snapshot.value;
          if (rawSnapshotValue is! Map<dynamic, dynamic>) {
            return const Center(child: Text('Format data karyawan tidak valid.'));
          }

          // Periksa role pengguna yang sedang login di node `users/{currentUser.uid}`
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
              // Banner informasi hak akses
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
                            ? 'Akses Admin Matrix Sphere aktif: Anda dapat memberikan dan mengubah jabatan karyawan.'
                            : 'Mode Lihat Saja: Hanya Admin Matrix Sphere yang dapat memberikan atau mengubah jabatan.',
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

              // Daftar karyawan
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
                        userData['role']?.toString() ?? 'Karyawan';

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
                                tooltip: 'Beri / Ubah Jabatan',
                                onPressed: () {
                                  _showAssignRoleDialog(
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

  /// Menampilkan dialog untuk memberikan atau mengubah jabatan karyawan.
  void _showAssignRoleDialog({
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
            'Akses ditolak: hanya Admin Matrix Sphere yang dapat memberikan jabatan.',
          ),
        ),
      );
      return;
    }

    final TextEditingController roleController =
        TextEditingController(text: currentRole);
    bool isSaving = false;
    String? errorText;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (
            BuildContext ctx,
            void Function(void Function()) setDialogState,
          ) {
            return AlertDialog(
              title: Text('Jabatan Karyawan: $currentName'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: roleController,
                      enabled: !isSaving,
                      decoration: InputDecoration(
                        labelText: 'Nama Jabatan',
                        hintText: 'Contoh: Staff Operasional',
                        errorText: errorText,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Saran jabatan cepat:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _suggestedRoles.map((String suggestion) {
                        return ActionChip(
                          label: Text(
                            suggestion,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: isSaving
                              ? null
                              : () {
                                  setDialogState(() {
                                    roleController.text = suggestion;
                                    errorText = null;
                                  });
                                },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final String newRole = roleController.text.trim();
                          if (newRole.isEmpty) {
                            setDialogState(() {
                              errorText = 'Jabatan tidak boleh kosong';
                            });
                            return;
                          }

                          setDialogState(() {
                            isSaving = true;
                            errorText = null;
                          });

                          try {
                            await FirebaseDatabase.instance
                                .ref('users/$uid')
                                .update(<String, dynamic>{
                              'role': newRole,
                            });

                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Jabatan "$newRole" diberikan kepada $currentName.',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal menyimpan jabatan: $e'),
                                  backgroundColor: Colors.red.shade700,
                                ),
                              );
                            }
                            setDialogState(() {
                              isSaving = false;
                            });
                          }
                        },
                  child: Text(isSaving ? 'Menyimpan...' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      roleController.dispose();
    });
  }
}