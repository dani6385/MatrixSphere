// lib/features/company/widgets/environment_work_hours_card.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Kartu pengaturan & tampilan jam kerja yang terpisah antar lingkungan aplikasi.
///
/// Contoh penggunaan:
/// - Lingkungan Matrix Sphere: `environmentKey: 'matrix_sphere'`
/// - Lingkungan Seller Sphere: `environmentKey: 'seller_sphere'`
class EnvironmentWorkHoursCard extends StatefulWidget {
  /// Kunci jalur di Firebase RTDB di bawah `work_schedules/{environmentKey}`.
  final String environmentKey;

  /// Nama tampilan lingkungan, contoh: "Matrix Sphere" atau "Seller Sphere".
  final String environmentLabel;

  /// Keterangan singkat peran pekerja pada lingkungan ini.
  final String roleDescription;

  const EnvironmentWorkHoursCard({
    super.key,
    required this.environmentKey,
    required this.environmentLabel,
    this.roleDescription = 'Pengaturan jam kerja pekerja',
  });

  @override
  State<EnvironmentWorkHoursCard> createState() =>
      _EnvironmentWorkHoursCardState();
}

class _EnvironmentWorkHoursCardState extends State<EnvironmentWorkHoursCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startTimeController =
      TextEditingController(text: '08:00');
  final TextEditingController _endTimeController =
      TextEditingController(text: '17:00');

  bool _isAttendanceEnabled = true;
  bool _isSaving = false;
  bool _hasLoadedInitialFromDb = false;

  DatabaseReference get _scheduleRef => FirebaseDatabase.instance
      .ref('work_schedules/${widget.environmentKey}');

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  /// Memvalidasi format jam 24 jam `HH:mm` (00:00 sampai 23:59).
  String? _validateTimeFormat(String? value) {
    final String text = (value ?? '').trim();
    if (text.isEmpty) {
      return 'Wajib diisi';
    }
    final RegExp timeRegex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    if (!timeRegex.hasMatch(text)) {
      return 'Gunakan format HH:mm (contoh: 08:00)';
    }
    return null;
  }

  /// Membuka pemilih jam (TimePicker) untuk mengisi TextField secara visual.
  Future<void> _pickTime(TextEditingController controller) async {
    TimeOfDay initialTime = const TimeOfDay(hour: 8, minute: 0);
    final List<String> parts = controller.text.trim().split(':');
    if (parts.length == 2) {
      final int? hour = int.tryParse(parts[0]);
      final int? minute = int.tryParse(parts[1]);
      if (hour != null &&
          minute != null &&
          hour >= 0 &&
          hour <= 23 &&
          minute >= 0 &&
          minute <= 59) {
        initialTime = TimeOfDay(hour: hour, minute: minute);
      }
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final String hh = picked.hour.toString().padLeft(2, '0');
      final String mm = picked.minute.toString().padLeft(2, '0');
      setState(() {
        controller.text = '$hh:$mm';
      });
    }
  }

  /// Menyimpan jam kerja ke jalur terpisah `work_schedules/{environmentKey}`.
  Future<void> _saveSchedule() async {
    if (_isSaving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final String startTime = _startTimeController.text.trim();
      final String endTime = _endTimeController.text.trim();

      await _scheduleRef.set(<String, dynamic>{
        'environment': widget.environmentKey,
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
            'Jam kerja ${widget.environmentLabel} disimpan ($startTime - $endTime)',
          ),
          backgroundColor: kBrandPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan jam kerja: $e'),
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<DatabaseEvent>(
      stream: _scheduleRef.onValue,
      builder: (context, snapshot) {
        Map<dynamic, dynamic> data = <dynamic, dynamic>{};
        if (snapshot.hasData &&
            snapshot.data!.snapshot.value != null &&
            snapshot.data!.snapshot.value is Map<dynamic, dynamic>) {
          data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        }

        final String dbStartTime =
            data['workStartTime']?.toString().trim().isNotEmpty == true
                ? data['workStartTime'].toString()
                : '08:00';
        final String dbEndTime =
            data['workEndTime']?.toString().trim().isNotEmpty == true
                ? data['workEndTime'].toString()
                : '17:00';
        final bool dbEnabled = data['isAttendanceEnabled'] is bool
            ? data['isAttendanceEnabled'] as bool
            : true;

        // Isi nilai awal TextField sekali saja saat data pertama kali dimuat dari RTDB
        if (!_hasLoadedInitialFromDb &&
            snapshot.connectionState != ConnectionState.waiting) {
          _hasLoadedInitialFromDb = true;
          _startTimeController.text = dbStartTime;
          _endTimeController.text = dbEndTime;
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
                  // Header Lingkungan
                  Row(
                    children: [
                      Icon(Icons.work_outline, color: kBrandPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jam Kerja ${widget.environmentLabel}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.roleDescription,
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Ringkasan jam kerja aktif tersimpan di lingkungan ini
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Aktif: $dbStartTime - $dbEndTime  •  Absensi: ${dbEnabled ? "Aktif" : "Nonaktif"}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // TextField Jam Mulai & Jam Selesai
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeField(
                          controller: _startTimeController,
                          label: 'Jam Mulai',
                          hint: '08:00',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTimeField(
                          controller: _endTimeController,
                          label: 'Jam Selesai',
                          hint: '17:00',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Aktifkan Absensi ${widget.environmentLabel}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
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
                    onPressed: _isSaving ? null : _saveSchedule,
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
                          : 'Simpan Jam Kerja ${widget.environmentLabel}',
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

  Widget _buildTimeField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      validator: _validateTimeFormat,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          tooltip: 'Pilih Jam',
          icon: const Icon(Icons.access_time, size: 20),
          onPressed: () => _pickTime(controller),
        ),
      ),
    );
  }
}