// lib/features/seller/widgets/seller_schedule_settings_card.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../models/attendance_paths.dart';

/// Admin pedagang dapat mengisi Jam Mulai & Jam Selesai lewat `TextField`
/// agar pekerja di bawah pedagang tersebut mengikuti jam kerja tokonya.
class SellerScheduleSettingsCard extends StatefulWidget {
  /// ID pedagang aktif. Jika `null`, menggunakan `uid` pengguna saat ini.
  final String? sellerId;

  const SellerScheduleSettingsCard({
    super.key,
    this.sellerId,
  });

  @override
  State<SellerScheduleSettingsCard> createState() =>
      _SellerScheduleSettingsCardState();
}

class _SellerScheduleSettingsCardState
    extends State<SellerScheduleSettingsCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startController =
      TextEditingController(text: '08:00');
  final TextEditingController _endController =
      TextEditingController(text: '17:00');

  bool _isAttendanceEnabled = true;
  bool _isSaving = false;
  bool _initializedFromDb = false;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  /// Validasi format 24 jam `HH:mm` (00:00 sampai 23:59).
  String? _validateTime(String? value) {
    final String text = (value ?? '').trim();
    if (text.isEmpty) {
      return 'Wajib diisi';
    }
    final RegExp regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    if (!regex.hasMatch(text)) {
      return 'Format HH:mm (contoh: 08:00)';
    }
    return null;
  }

  Future<void> _pickTime(TextEditingController controller) async {
    TimeOfDay initial = const TimeOfDay(hour: 8, minute: 0);
    final List<String> parts = controller.text.trim().split(':');
    if (parts.length == 2) {
      final int? h = int.tryParse(parts[0]);
      final int? m = int.tryParse(parts[1]);
      if (h != null && m != null && h >= 0 && h <= 23 && m >= 0 && m <= 59) {
        initial = TimeOfDay(hour: h, minute: m);
      }
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked != null) {
      final String hh = picked.hour.toString().padLeft(2, '0');
      final String mm = picked.minute.toString().padLeft(2, '0');
      setState(() {
        controller.text = '$hh:$mm';
      });
    }
  }

  Future<void> _saveSellerSchedule(DatabaseReference scheduleRef, String effectiveSellerId) async {
    if (_isSaving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final String startTime = _startController.text.trim();
      final String endTime = _endController.text.trim();

      await scheduleRef.set(<String, dynamic>{
        'environment': AttendancePaths.sellerEnv,
        'sellerId': effectiveSellerId,
        'workStartTime': startTime,
        'workEndTime': endTime,
        'isAttendanceEnabled': _isAttendanceEnabled,
        'updatedAt': ServerValue.timestamp,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Jam kerja pedagang disimpan ($startTime - $endTime)',
          ),
          backgroundColor: kBrandPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan jam kerja pedagang: $e'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const SizedBox.shrink();
    }

    final String effectiveSellerId = AttendancePaths.resolveSellerId(
      sellerId: widget.sellerId,
      fallbackUid: user.uid,
    );
    final String path = AttendancePaths.workSchedule(
      environmentKey: AttendancePaths.sellerEnv,
      uid: user.uid,
      sellerId: effectiveSellerId,
    );
    final DatabaseReference scheduleRef = FirebaseDatabase.instance.ref(path);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<DatabaseEvent>(
      stream: scheduleRef.onValue,
      builder: (context, snapshot) {
        Map<dynamic, dynamic> data = <dynamic, dynamic>{};
        if (snapshot.hasData &&
            snapshot.data!.snapshot.value != null &&
            snapshot.data!.snapshot.value is Map<dynamic, dynamic>) {
          data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        }

        final String dbStart =
            data['workStartTime']?.toString().trim().isNotEmpty == true
                ? data['workStartTime'].toString()
                : '08:00';
        final String dbEnd =
            data['workEndTime']?.toString().trim().isNotEmpty == true
                ? data['workEndTime'].toString()
                : '17:00';
        final bool dbEnabled = data['isAttendanceEnabled'] is bool
            ? data['isAttendanceEnabled'] as bool
            : true;

        if (!_initializedFromDb &&
            snapshot.connectionState != ConnectionState.waiting) {
          _initializedFromDb = true;
          _startController.text = dbStart;
          _endController.text = dbEnd;
          _isAttendanceEnabled = dbEnabled;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Jam Kerja Pedagang (Seller Sphere)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ID Pedagang: $effectiveSellerId • Berlaku untuk pekerja di bawah pedagang ini',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startController,
                          keyboardType: TextInputType.datetime,
                          validator: _validateTime,
                          decoration: InputDecoration(
                            labelText: 'Jam Mulai',
                            hintText: '08:00',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              tooltip: 'Pilih Jam Mulai',
                              icon: const Icon(Icons.access_time, size: 20),
                              onPressed: () => _pickTime(_startController),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _endController,
                          keyboardType: TextInputType.datetime,
                          validator: _validateTime,
                          decoration: InputDecoration(
                            labelText: 'Jam Selesai',
                            hintText: '17:00',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              tooltip: 'Pilih Jam Selesai',
                              icon: const Icon(Icons.access_time, size: 20),
                              onPressed: () => _pickTime(_endController),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Aktifkan Absensi Pekerja Toko',
                      style:
                          TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                    value: _isAttendanceEnabled,
                    onChanged: (bool val) {
                      setState(() {
                        _isAttendanceEnabled = val;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () => _saveSellerSchedule(
                              scheduleRef,
                              effectiveSellerId,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBrandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _isSaving
                          ? 'Menyimpan...'
                          : 'Simpan Jam Kerja Pedagang',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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