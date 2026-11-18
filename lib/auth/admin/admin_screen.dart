// lib/screens/admin/manage_users_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_navigations/shared_navigations.dart'; // Pastikan Anda memiliki file ini untuk navigasi

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Jabatan Pekerja'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.goBack(context),
        ),
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

          final Map<dynamic, dynamic> usersMap =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          final List<MapEntry<dynamic, dynamic>> userEntries =
              usersMap.entries.toList();

          return ListView.builder(
            itemCount: userEntries.length,
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (context, index) {
              final userId = userEntries[index].key;
              final userData = userEntries[index].value as Map<dynamic, dynamic>;

              final String name = userData['name']?.toString() ?? 'Tanpa Nama';
              final String email = userData['email']?.toString() ?? 'Tidak ada email';
              final String role = userData['role']?.toString() ?? 'Pekerja / Karyawan';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('$email\nJabatan: $role'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: 'Ubah Jabatan',
                    onPressed: () {
                      _showEditRoleDialog(context, userId, name, role);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fungsi dialog untuk mengubah jabatan pekerja
  void _showEditRoleDialog(BuildContext context, String uid, String currentName, String currentRole) {
    final TextEditingController roleController = TextEditingController(text: currentRole);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      ElevatedButton(
        onPressed: () async {
          final newRole = roleController.text.trim();
          if (newRole.isNotEmpty) {
            // Perbarui data role di Firebase RTDB
            await FirebaseDatabase.instance.ref('users/$uid').update({
              'role': newRole,
            });
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Jabatan berhasil diperbarui!')),
              );
            }
          }
        },
        child: const Text('Simpan'),
      ),
        ],
      ),
    );
  }
}