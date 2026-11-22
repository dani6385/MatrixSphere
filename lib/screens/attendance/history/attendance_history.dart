// lib/screens/attendance/attendance_history.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'attendance_day_detail_card.dart';

/// Halaman Riwayat Absensi (`AttendanceHistoryScreen`) dengan:
/// 1. Ringkasan jumlah hari hadir & belum pulang pada bulan yang dipilih.
/// 2. Kalender bulanan interaktif.
/// 3. Kartu detail harian (`AttendanceDayDetailCard`) + aksi lengkapi Check-Out.
class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
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

  String _toDateKey(DateTime date) {
    final String yyyy = date.year.toString().padLeft(4, '0');
    final String mm = date.month.toString().padLeft(2, '0');
    final String dd = date.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  String _toMonthPrefix(DateTime monthDate) {
    final String yyyy = monthDate.year.toString().padLeft(4, '0');
    final String mm = monthDate.month.toString().padLeft(2, '0');
    return '$yyyy-$mm-';
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth =
          DateTime(_focusedMonth.year, _focusedMonth.month + offset, 1);
    });
  }

  void _goToToday() {
    final DateTime now = DateTime.now();
    setState(() {
      _focusedMonth = DateTime(now.year, now.month, 1);
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
  }

  String _formatMonthYear(DateTime date) {
    const List<String> monthNames = <String>[
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
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Melengkapi Check-Out untuk tanggal yang dipilih lewat TimePicker.
  Future<void> _completeCheckOutForDate({
    required String uid,
    required String dateKey,
  }) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Pilih Jam Pulang (Check-Out)',
    );

    if (pickedTime == null) return;

    final String hh = pickedTime.hour.toString().padLeft(2, '0');
    final String mm = pickedTime.minute.toString().padLeft(2, '0');
    final String formattedTime = '$hh:$mm';

    try {
      final DatabaseReference dayRef = FirebaseDatabase.instance
          .ref('history_attendance/$uid/$dateKey');
      await dayRef.update(<String, dynamic>{
        'checkOutTime': formattedTime,
        'checkOutTimestamp': ServerValue.timestamp,
        'status': 'completed',
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Check-Out tanggal $dateKey dilengkapi ($formattedTime)'),
          backgroundColor: kBrandPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal melengkapi Check-Out: $e'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Riwayat Absensi')),
        body: const Center(
          child: Text('Silakan login terlebih dahulu untuk melihat riwayat.'),
        ),
      );
    }

    final DatabaseReference historyRef =
        FirebaseDatabase.instance.ref('history_attendance/${user.uid}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absensi'),
        actions: [
          TextButton.icon(
            onPressed: _goToToday,
            icon: const Icon(Icons.today, size: 18),
            label: const Text('Hari Ini'),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: historyRef.onValue,
        builder: (context, snapshot) {
          final Map<String, Map<dynamic, dynamic>> attendanceMap =
              <String, Map<dynamic, dynamic>>{};

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final Object? raw = snapshot.data!.snapshot.value;
            if (raw is Map<dynamic, dynamic>) {
              raw.forEach((key, value) {
                if (value is Map<dynamic, dynamic>) {
                  attendanceMap[key.toString()] = value;
                }
              });
            }
          }

          // Hitung ringkasan kehadiran pada bulan yang sedang dibuka (`_focusedMonth`)
          final String monthPrefix = _toMonthPrefix(_focusedMonth);
          int completedDays = 0;
          int missingCheckOutDays = 0;

          attendanceMap.forEach((String key, Map<dynamic, dynamic> record) {
            if (key.startsWith(monthPrefix)) {
              final String? cIn = record['checkInTime']?.toString();
              final String? cOut = record['checkOutTime']?.toString();
              final bool hasIn = cIn != null && cIn.trim().isNotEmpty;
              final bool hasOut = cOut != null && cOut.trim().isNotEmpty;

              if (hasIn && hasOut) {
                completedDays++;
              } else if (hasIn && !hasOut) {
                missingCheckOutDays++;
              }
            }
          });

          final String selectedKey = _toDateKey(_selectedDate);
          final Map<dynamic, dynamic>? selectedDayData =
              attendanceMap[selectedKey];

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              // 1. RINGKASAN KEHADIRAN BULAN INI
              _buildMonthlySummaryCard(
                monthLabel: _formatMonthYear(_focusedMonth),
                completedDays: completedDays,
                missingCheckOutDays: missingCheckOutDays,
              ),

              const SizedBox(height: 14),

              // 2. KARTU KALENDER BULANAN
              _buildCalendarCard(attendanceMap),

              const SizedBox(height: 16),

              // 3. KARTU DETAIL HARIAN (DETAIL DAY)
              const Text(
                'Detail Kehadiran Harian',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kDarkTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              AttendanceDayDetailCard(
                selectedDate: _selectedDate,
                dayData: selectedDayData,
                onCompleteCheckOut: () => _completeCheckOutForDate(
                  uid: user.uid,
                  dateKey: selectedKey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Kartu ringkasan jumlah hari hadir lengkap & belum pulang dalam 1 bulan.
  Widget _buildMonthlySummaryCard({
    required String monthLabel,
    required int completedDays,
    required int missingCheckOutDays,
  }) {
    final int totalRecordedDays = completedDays + missingCheckOutDays;

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Bulan $monthLabel',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kDarkTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SummaryCounterBox(
                    label: 'Hadir Lengkap',
                    count: completedDays,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SummaryCounterBox(
                    label: 'Belum Pulang',
                    count: missingCheckOutDays,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SummaryCounterBox(
                    label: 'Total Tercatat',
                    count: totalRecordedDays,
                    color: kBrandPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard(
    Map<String, Map<dynamic, dynamic>> attendanceMap,
  ) {
    final DateTime today = DateTime.now();
    final int daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final int leadingEmptyCells = _focusedMonth.weekday - 1;
    final int totalCells = leadingEmptyCells + daysInMonth;

    const List<String> weekDayLabels = <String>[
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min',
    ];

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: 'Bulan Sebelumnya',
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  _formatMonthYear(_focusedMonth),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkTextPrimary,
                  ),
                ),
                IconButton(
                  tooltip: 'Bulan Berikutnya',
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: weekDayLabels.map((String label) {
                final bool isSunday = label == 'Min';
                return Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSunday
                            ? Colors.red.shade600
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalCells,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                if (index < leadingEmptyCells) {
                  return const SizedBox.shrink();
                }

                final int dayNumber = index - leadingEmptyCells + 1;
                final DateTime cellDate = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month,
                  dayNumber,
                );
                final String cellKey = _toDateKey(cellDate);
                final Map<dynamic, dynamic>? record = attendanceMap[cellKey];

                final bool isSelected = _isSameDay(cellDate, _selectedDate);
                final bool isToday = _isSameDay(cellDate, today);

                Color? dotColor;
                if (record != null) {
                  final String? checkIn = record['checkInTime']?.toString();
                  final String? checkOut = record['checkOutTime']?.toString();
                  if (checkIn != null &&
                      checkIn.isNotEmpty &&
                      checkOut != null &&
                      checkOut.isNotEmpty) {
                    dotColor = Colors.green;
                  } else if (checkIn != null && checkIn.isNotEmpty) {
                    dotColor = Colors.deepOrange;
                  }
                }

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDate = cellDate;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? kBrandPrimary
                          : (isToday
                              ? kBrandPrimary.withValues(alpha: 0.12)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                      border: isToday && !isSelected
                          ? Border.all(color: kBrandPrimary, width: 1.2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: (isSelected || isToday)
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (cellDate.weekday == DateTime.sunday
                                    ? Colors.red.shade600
                                    : kDarkTextPrimary),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotColor == null
                                ? Colors.transparent
                                : (isSelected ? Colors.white : dotColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: Colors.green, label: 'Lengkap'),
                const SizedBox(width: 16),
                _LegendDot(color: Colors.deepOrange, label: 'Belum Pulang'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCounterBox extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryCounterBox({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: kDarkTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}