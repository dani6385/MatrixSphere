// lib/screens/Attendance/screens/attendance_history_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models/attendance_history_item.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  String _formatDateKey(DateTime dt) {
    final String yyyy = dt.year.toString().padLeft(4, '0');
    final String mm = dt.month.toString().padLeft(2, '0');
    final String dd = dt.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  String _formatMonthTitle(DateTime month) {
    const List<String> months = <String>[
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${months[month.month - 1]} ${month.year}';
  }

  Map<String, AttendanceHistoryItem> _parseHistoryMap(Object? rawValue) {
    final Map<String, AttendanceHistoryItem> result =
        <String, AttendanceHistoryItem>{};
    if (rawValue == null || rawValue is! Map<dynamic, dynamic>) {
      return result;
    }

    rawValue.forEach((dynamic key, dynamic value) {
      final String keyStr = key.toString().trim();
      if (AttendanceHistoryItem.isDateKey(keyStr) &&
          value is Map<dynamic, dynamic>) {
        result[keyStr] = AttendanceHistoryItem.fromMap(
          dateKey: keyStr,
          map: value,
        );
      }
    });

    return result;
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Riwayat Absensi'),
      ),
      body: user == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Silakan login untuk melihat kalender riwayat absensi.'),
              ),
            )
          : StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref('attendance/matrix/${user.uid}')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Gagal memuat data kalender: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final Map<String, AttendanceHistoryItem> historyMap =
                    _parseHistoryMap(snapshot.data?.snapshot.value);
                final String selectedKey = _formatDateKey(_selectedDate);
                final AttendanceHistoryItem? selectedItem = historyMap[selectedKey];

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildMonthHeader(),
                    const SizedBox(height: 12),
                    _buildLegend(),
                    const SizedBox(height: 12),
                    _buildCalendarCard(historyMap),
                    const SizedBox(height: 16),
                    _buildSelectedDateDetail(
                      dateKey: selectedKey,
                      item: selectedItem,
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Bulan Sebelumnya',
          onPressed: () => _changeMonth(-1),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          _formatMonthTitle(_focusedMonth),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          tooltip: 'Bulan Berikutnya',
          onPressed: () => _changeMonth(1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendDot(color: Colors.green.shade600, label: 'Sudah Absen'),
        const SizedBox(width: 20),
        _LegendDot(color: Colors.red.shade600, label: 'Tidak Absen'),
      ],
    );
  }

  Widget _buildCalendarCard(Map<String, AttendanceHistoryItem> historyMap) {
    final DateTime now = DateTime.now();
    final DateTime todayOnly = DateTime(now.year, now.month, now.day);

    final int year = _focusedMonth.year;
    final int month = _focusedMonth.month;
    final int daysInMonth = DateTime(year, month + 1, 0).day;
    final int firstWeekday = DateTime(year, month, 1).weekday; // 1 = Senin .. 7 = Minggu

    const List<String> dayNames = <String>[
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min',
    ];

    final List<Widget> cells = <Widget>[];

    // Slot kosong sebelum tanggal 1
    for (int i = 1; i < firstWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime dateObj = DateTime(year, month, day);
      final String dateKey = _formatDateKey(dateObj);
      final bool hasAttended = historyMap.containsKey(dateKey);
      final bool isPastOrToday = !dateObj.isAfter(todayOnly);
      final bool isSelected =
          _selectedDate.year == year &&
          _selectedDate.month == month &&
          _selectedDate.day == day;

      Color bgColor;
      Color textColor;

      if (hasAttended) {
        bgColor = Colors.green.shade600;
        textColor = Colors.white;
      } else if (isPastOrToday) {
        bgColor = Colors.red.shade600;
        textColor = Colors.white;
      } else {
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
      }

      cells.add(
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              _selectedDate = dateObj;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: Colors.amber.shade300, width: 3)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.6,
              children: dayNames
                  .map(
                    (d) => Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 6),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: cells,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDateDetail({
    required String dateKey,
    required AttendanceHistoryItem? item,
  }) {
    final bool attended = item != null;

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detail Tanggal: $dateKey',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: attended
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    attended ? 'Sudah Absen' : 'Tidak Absen',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: attended
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!attended)
              Text(
                'Tidak ada catatan absensi pada tanggal $dateKey.',
                style: TextStyle(color: Colors.grey.shade700),
              )
            else ...[
              Text(
                'Status: ${item.displayStatusLabel}',
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                'Jam Masuk: ${item.checkInTime}  •  Jam Pulang: ${item.checkOutTime}',
                style: const TextStyle(color: Colors.black87),
              ),
              if (item.checkInDistanceMeters != null ||
                  item.checkOutDistanceMeters != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Jarak Masuk: ${item.checkInDistanceMeters ?? '-'} m  •  Jarak Pulang: ${item.checkOutDistanceMeters ?? '-'} m',
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 12.5),
                ),
              ],
              if (item.note.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  'Catatan: ${item.note}',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontStyle: FontStyle.italic,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}