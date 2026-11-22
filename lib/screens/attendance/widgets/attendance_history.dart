// lib/screens/Attendance/widgets/attendance_history.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/attendance_history_item.dart';

/// Daftar riwayat absensi harian pengguna untuk **Matrix Sphere**.
class AttendanceHistory extends StatelessWidget {
  final String title;
  final int maxItems;

  const AttendanceHistory({
    super.key,
    this.title = 'Riwayat Absensi',
    this.maxItems = 30,
  });

  List<AttendanceHistoryItem> _parseHistoryItems(Object? rawValue) {
    if (rawValue == null || rawValue is! Map<dynamic, dynamic>) {
      return <AttendanceHistoryItem>[];
    }

    final List<AttendanceHistoryItem> items = <AttendanceHistoryItem>[];

    rawValue.forEach((dynamic key, dynamic value) {
      final String keyStr = key.toString().trim();
      if (AttendanceHistoryItem.isDateKey(keyStr) &&
          value is Map<dynamic, dynamic>) {
        items.add(
          AttendanceHistoryItem.fromMap(
            dateKey: keyStr,
            map: value,
          ),
        );
      }
    });

    // Urutkan dari tanggal terbaru ke terlama (YYYY-MM-DD)
    items.sort((a, b) => b.dateKey.compareTo(a.dateKey));

    if (items.length > maxItems) {
      return items.sublist(0, maxItems);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Silakan login untuk melihat riwayat absensi.'),
        ),
      );
    }

    final DatabaseReference userHistoryRef = FirebaseDatabase.instance.ref(
      'attendance/matrix/${user.uid}',
    );

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.history,
                  color: Colors.black87,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<DatabaseEvent>(
              stream: userHistoryRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Text(
                    'Gagal memuat riwayat absensi: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.red.shade700,
                    ),
                  );
                }

                final List<AttendanceHistoryItem> historyList =
                    _parseHistoryItems(snapshot.data?.snapshot.value);

                if (historyList.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Belum ada riwayat absensi yang tercatat.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historyList.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _AttendanceHistoryTile(item: historyList[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceHistoryTile extends StatelessWidget {
  final AttendanceHistoryItem item;

  const _AttendanceHistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = item.statusColor;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.statusIcon, size: 18, color: statusColor),
              const SizedBox(width: 6),
              Text(
                item.dateKey,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.displayStatusLabel,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Masuk: ${item.checkInTime}',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Pulang: ${item.checkOutTime}',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (item.checkInDistanceMeters != null ||
              item.checkOutDistanceMeters != null) ...[
            const SizedBox(height: 6),
            Text(
              _buildDistanceSummary(),
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
          if (item.note.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Catatan: ${item.note}',
              style: TextStyle(
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildDistanceSummary() {
    final List<String> parts = <String>[];
    if (item.checkInDistanceMeters != null) {
      parts.add('Jarak Masuk: ${item.checkInDistanceMeters} m');
    }
    if (item.checkOutDistanceMeters != null) {
      parts.add('Jarak Pulang: ${item.checkOutDistanceMeters} m');
    }
    return parts.join(' • ');
  }
}