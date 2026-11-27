import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Kartu formulir dengan `TextField` untuk mengisi Jam Mulai & Jam Selesai kerja
/// bagi **Matrix Sphere** dan **Seller Sphere**, lalu menyimpannya ke `company_profile`.
class WorkHoursFormCard extends StatefulWidget {
  final String initialMatrixStart;
  final String initialMatrixEnd;
  final String initialSellerStart;
  final String initialSellerEnd;
  final bool initialAttendanceEnabled;

  const WorkHoursFormCard({
    super.key,
    this.initialMatrixStart = '08:00',
    this.initialMatrixEnd = '17:00',
    this.initialSellerStart = '08:00',
    this.initialSellerEnd = '17:00',
    this.initialAttendanceEnabled = true,
  });

  @override
  State<WorkHoursFormCard> createState() => _WorkHoursFormCardState();
}

class _WorkHoursFormCardState extends State<WorkHoursFormCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _matrixStartController;
  late final TextEditingController _matrixEndController;
  late final TextEditingController _sellerStartController;
  late final TextEditingController _sellerEndController;

  late bool _isAttendanceEnabled;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _matrixStartController =
        TextEditingController(text: widget.initialMatrixStart);
    _matrixEndController =
        TextEditingController(text: widget.initialMatrixEnd);
    _sellerStartController =
        TextEditingController(text: widget.initialSellerStart);
    _sellerEndController =
        TextEditingController(text: widget.initialSellerEnd);
    _isAttendanceEnabled = widget.initialAttendanceEnabled;
  }

  @override
  void didUpdateWidget(covariant WorkHoursFormCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sinkronkan controller jika nilai dari database berubah dan belum sedang diedit
    if (oldWidget.initialMatrixStart != widget.initialMatrixStart) {
      _matrixStartController.text = widget.initialMatrixStart;
    }
    if (oldWidget.initialMatrixEnd != widget.initialMatrixEnd) {
      _matrixEndController.text = widget.initialMatrixEnd;
    }
    if (oldWidget.initialSellerStart != widget.initialSellerStart) {
      _sellerStartController.text = widget.initialSellerStart;
    }
    if (oldWidget.initialSellerEnd != widget.initialSellerEnd) {
      _sellerEndController.text = widget.initialSellerEnd;
    }
    if (oldWidget.initialAttendanceEnabled != widget.initialAttendanceEnabled) {
      _isAttendanceEnabled = widget.initialAttendanceEnabled;
    }
  }

  @override
  void dispose() {
    _matrixStartController.dispose();
    _matrixEndController.dispose();
    _sellerStartController.dispose();
    _sellerEndController.dispose();
    super.dispose();
  }

  /// Memvalidasi apakah teks jam sesuai format 24 jam `HH:mm` (00:00 - 23:59).
  String? _validateTimeFormat(String? value) {
    final String text = (value ?? '').trim();
    if (text.isEmpty) {
      return 'Wajib diisi';
    }
    final RegExp timePattern = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    if (!timePattern.hasMatch(text)) {
      return 'Format HH:mm (contoh: 08:00)';
    }
    return null;
  }

  /// Membuka TimePicker untuk membantu mengisi TextField jika pengguna tidak ingin mengetik manual.
  Future<void> _pickTimeIntoController(TextEditingController controller) async {
    TimeOfDay initialTime = const TimeOfDay(hour: 8, minute: 0);
    final List<String> parts = controller.text.trim().split(':');
    if (parts.length == 2) {
      final int? h = int.tryParse(parts[0]);
      final int? m = int.tryParse(parts[1]);
      if (h != null && m != null && h >= 0 && h <= 23 && m >= 0 && m <= 59) {
        initialTime = TimeOfDay(hour: h, minute: m);
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

  Future<void> _saveWorkHours() async {
    if (_isSaving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final String matrixStart = _matrixStartController.text.trim();
      final String matrixEnd = _matrixEndController.text.trim();
      final String sellerStart = _sellerStartController.text.trim();
      final String sellerEnd = _sellerEndController.text.trim();

      final DatabaseReference companyRef =
          FirebaseDatabase.instance.ref('company_profile');

      await companyRef.update(<String, dynamic>{
        // Field utama (kompatibel dengan AttendanceActionCard)
        'workStartTime': sellerStart,
        'workEndTime': sellerEnd,
        'isAttendanceEnabled': _isAttendanceEnabled,

        // Field khusus masing-masing unit: Matrix Sphere & Seller Sphere
        'matrixSphereWorkStart': matrixStart,
        'matrixSphereWorkEnd': matrixEnd,
        'sellerSphereWorkStart': sellerStart,
        'sellerSphereWorkEnd': sellerEnd,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Jam kerja Matrix Sphere',
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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
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
              Row(
                children: [
                  Icon(Icons.schedule, color: kBrandPrimary),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Pengaturan Jam Kerja',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Isi format jam 24 jam (HH:mm), contoh: 08:00 dan 17:00.',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // 1. Bagian Matrix Sphere
              const Text(
                'Matrix Sphere',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeTextField(
                      controller: _matrixStartController,
                      label: 'Jam Mulai',
                      hint: '08:00',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimeTextField(
                      controller: _matrixEndController,
                      label: 'Jam Selesai',
                      hint: '17:00',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveWorkHours,
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
                  _isSaving ? 'Menyimpan...' : 'Simpan Jam Kerja',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper pembuat `TextField` (`TextFormField`) jam mulai / jam selesai.
  Widget _buildTimeTextField({
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
          onPressed: () => _pickTimeIntoController(controller),
        ),
      ),
    );
  }
}