import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class ProjectBody extends StatefulWidget {
  const ProjectBody({super.key});

  @override
  State<ProjectBody> createState() => _ProjectBodyState();
}

class _ProjectBodyState extends State<ProjectBody> {
  final DatabaseReference _errorsRef = FirebaseDatabase.instance.ref('app_errors');
  String _selectedAppFilter = 'Semua';

  // Daftar filter aplikasi anak di monorepo
  final List<String> _appFilters = [
    'Semua',
    'admin_mikrotik',
    'client_connectivity',
    'seller_sphere',
    'shop_sphere',
  ];

  // Fungsi untuk menandai error sudah diperbaiki
  Future<void> _markAsResolved(String errorId) async {
    await _errorsRef.child(errorId).update({'status': 'resolved'});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status error diperbarui menjadi Selesai (Resolved).'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Fungsi untuk menghapus log error
  Future<void> _deleteErrorLog(String errorId) async {
    await _errorsRef.child(errorId).remove();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Log error berhasil dihapus.')),
    );
  }

  // Menampilkan dialog detail lengkap & StackTrace untuk debugging
  void _showErrorDetailDialog(Map<dynamic, dynamic> data) {
    final String stackTrace = data['stackTrace'] ?? 'Tidak ada detail stack trace';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.bug_report, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Detail Error: ${data['appName']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Aplikasi', '${data['appName']} (v${data['appVersion'] ?? '-'})'),
                _buildInfoRow('Waktu', data['timestamp'] ?? '-'),
                _buildInfoRow('Pengguna', data['userEmail'] ?? '-'),
                _buildInfoRow('Perangkat HP', data['deviceInfo'] ?? '-'),
                _buildInfoRow('Konteks', data['contextInfo'] ?? '-'),
                const Divider(height: 20),
                const Text(
                  'Pesan Error:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SelectableText(
                    data['errorMessage'] ?? '-',
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Stack Trace (Jejak Kode):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Salin'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: stackTrace));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Stack trace disalin ke clipboard!')),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      stackTrace,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (data['status'] != 'resolved')
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text('Tandai Selesai'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                _markAsResolved(data['id']);
              },
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  // Warna badge pembeda tiap aplikasi anak
  Color _getAppBadgeColor(String appName) {
    switch (appName) {
      case 'admin_mikrotik':
        return Colors.indigo;
      case 'client_connectivity':
        return Colors.teal;
      case 'seller_sphere':
        return Colors.deepOrange;
      case 'shop_sphere':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bar Filter Aplikasi di bagian atas
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.grey.shade100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _appFilters.map((app) {
                final isSelected = _selectedAppFilter == app;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(app),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedAppFilter = app);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Daftar Laporan Error Real-Time dari Firebase RTDB
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: _errorsRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user, size: 64, color: Colors.green),
                      SizedBox(height: 12),
                      Text(
                        'Semua Sistem Normal! Tidak ada laporan error.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }

              // Mengubah data Map RTDB menjadi List dan mengurutkannya dari yang terbaru
              final rawMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              final List<Map<dynamic, dynamic>> errorList = rawMap.values
                  .map((e) => e as Map<dynamic, dynamic>)
                  .where((item) {
                    if (_selectedAppFilter == 'Semua') return true;
                    return item['appName'] == _selectedAppFilter;
                  })
                  .toList();

              // Urutkan berdasarkan timestamp terbaru di atas
              errorList.sort((a, b) => (b['timestamp'] ?? '').compareTo(a['timestamp'] ?? ''));

              if (errorList.isEmpty) {
                return Center(
                  child: Text('Tidak ada laporan error untuk $_selectedAppFilter.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: errorList.length,
                itemBuilder: (context, index) {
                  final err = errorList[index];
                  final String appName = err['appName'] ?? 'unknown';
                  final bool isResolved = err['status'] == 'resolved';

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isResolved ? Colors.green.shade200 : Colors.red.shade200,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      onTap: () => _showErrorDetailDialog(err),
                      leading: CircleAvatar(
                        backgroundColor: isResolved ? Colors.green.shade100 : Colors.red.shade100,
                        child: Icon(
                          isResolved ? Icons.check : Icons.warning_amber_rounded,
                          color: isResolved ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getAppBadgeColor(appName),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              appName,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              err['timestamp'] ?? '',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            err['errorMessage'] ?? 'Error tidak diketahui',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'HP: ${err['deviceInfo'] ?? '-'} • User: ${err['userEmail'] ?? '-'}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        tooltip: 'Hapus Log',
                        onPressed: () => _deleteErrorLog(err['id']),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}