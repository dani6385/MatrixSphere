// lib/screens/attendance/attendance_history.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

// Sesuaikan path import ini dengan lokasi AttendanceHistoryScreen di proyekmu
import '../attendance_history_screen.dart';

/// Kartu ringkasan Riwayat Absensi untuk ditampilkan di `AttendanceScreen`.
/// Mengetuk kartu ini akan membuka `AttendanceHistoryScreen` (halaman kalender).
class AttendanceHistory extends StatelessWidget {
  final String title;

  const AttendanceHistory({
    super.key,
    this.title = 'Riwayat Absensi',
  });

  String _currentMonthPrefix() {
    final DateTime now = DateTime.now();
    final String yyyy = now.year.toString().padLeft(4, '0');
    final String mm = now.month.toString().padLeft(2, '0');
    return '$yyyy-$mm-';
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Silakan login untuk melihat riwayat absensi.',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      );
    }

    final DatabaseReference historyRef = FirebaseDatabase.instance.ref(
      'attendance/matrix/${user.uid}',
    );
    final String monthPrefix = _currentMonthPrefix();

    return StreamBuilder<DatabaseEvent>(
      stream: historyRef.onValue,
      builder: (context, snapshot) {
        int attendedThisMonth = 0;
        String latestDate = '-';
        String latestStatus = 'Belum ada catatan';

        if (snapshot.hasData && snapshot.data!.snapshot.value is Map) {
          final Map<dynamic, dynamic> rawMap =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          final List<String> dateKeys = <String>[];

          rawMap.forEach((key, value) {
            final String k = key.toString().trim();
            if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(k) &&
                value is Map<dynamic, dynamic>) {
              dateKeys.add(k);
              if (k.startsWith(monthPrefix)) {
                attendedThisMonth++;
              }
            }
          });

          dateKeys.sort((a, b) => b.compareTo(a));
          if (dateKeys.isNotEmpty) {
            latestDate = dateKeys.first;
            final Map<dynamic, dynamic> lastRec =
                rawMap[latestDate] as Map<dynamic, dynamic>;
            latestStatus = lastRec['status']?.toString() ?? 'Tercatat';
          }
        }

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AttendanceHistoryScreen(),
              ),
            );
          },
          child: Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: kBrandPrimary,
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
                      Text(
                        'Buka Kalender',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.grey.shade700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hadir Bulan Ini: $attendedThisMonth hari',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Terakhir: $latestDate',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status terakhir: $latestStatus',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}