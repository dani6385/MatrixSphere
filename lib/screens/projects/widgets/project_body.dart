import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:matrix_sphere/screens/projects/models/app_error_model.dart';
import 'body/app_filter_bar.dart';
import 'body/empty_error_state.dart';
import 'body/error_log_card.dart';
import 'body/error_detail_dialog.dart';

/// Kerangka utama (Body) untuk halaman Project yang mengatur aliran data
/// error dari Firebase RTDB dan menyusun komponen antarmuka.
class ProjectBody extends StatefulWidget {
  const ProjectBody({super.key});

  @override
  State<ProjectBody> createState() => _ProjectBodyState();
}

class _ProjectBodyState extends State<ProjectBody> {
  final DatabaseReference _errorsRef = FirebaseDatabase.instance.ref('app_errors');
  String _selectedAppFilter = 'Semua';

  static const List<String> _appFilters = [
    'Semua',
    'admin_mikrotik',
    'client_connectivity',
    'seller_sphere',
    'shop_sphere',
  ];

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

  Future<void> _deleteErrorLog(String errorId) async {
    await _errorsRef.child(errorId).remove();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Log error berhasil dihapus.')),
    );
  }

  void _openDetailDialog(AppErrorModel error) {
    showDialog(
      context: context,
      builder: (_) => ErrorDetailDialog(
        error: error,
        onMarkResolved: () => _markAsResolved(error.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Komponen Filter Aplikasi
        AppFilterBar(
          filters: _appFilters,
          selectedFilter: _selectedAppFilter,
          onFilterChanged: (newFilter) {
            setState(() => _selectedAppFilter = newFilter);
          },
        ),

        // 2. Daftar Laporan Error Real-Time
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: _errorsRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return const EmptyErrorState(
                  message: 'Semua Sistem Normal! Tidak ada laporan error.',
                  showIcon: true,
                );
              }

              final rawMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              final errorList = rawMap.entries
                  .map((entry) => AppErrorModel.fromMap(
                        entry.key.toString(),
                        entry.value as Map<dynamic, dynamic>,
                      ))
                  .where((item) =>
                      _selectedAppFilter == 'Semua' || item.appName == _selectedAppFilter)
                  .toList()
                ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

              if (errorList.isEmpty) {
                return EmptyErrorState(
                  message: 'Tidak ada laporan error untuk $_selectedAppFilter.',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: errorList.length,
                itemBuilder: (context, index) {
                  final errorItem = errorList[index];
                  return ErrorLogCard(
                    error: errorItem,
                    onTap: () => _openDetailDialog(errorItem),
                    onDelete: () => _deleteErrorLog(errorItem.id),
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