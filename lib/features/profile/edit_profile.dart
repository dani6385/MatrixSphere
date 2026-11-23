// lib/features/profile/edit_profile.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
/// Helper memformat DateTime menjadi YYYY-MM-DD
String formatDateToIso(DateTime date) {
  final String y = date.year.toString().padLeft(4, '0');
  final String m = date.month.toString().padLeft(2, '0');
  final String d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Helper mem-parsing string YYYY-MM-DD menjadi DateTime
DateTime? parseIsoDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final List<String> parts = raw.trim().split('-');
  if (parts.length != 3) return null;
  final int? y = int.tryParse(parts[0]);
  final int? m = int.tryParse(parts[1]);
  final int? d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

/// Helper memformat tanggal ke tampilan Indonesia (contoh: 22 November 2026)
String formatIndonesianDate(DateTime date) {
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
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

/// Menyimpan tanggal mulai bekerja user (`startDate` format YYYY-MM-DD)
/// ke node RTDB `matrix_members/$uid`.
Future<void> setUserStartDate({
  required String uid,
  required DateTime startDate,
}) async {
  await FirebaseDatabase.instance
      .ref('matrix_members/$uid')
      .update(<String, dynamic>{
    'startDate': formatDateToIso(startDate),
  });
}

class EditProfileScreen extends StatefulWidget {
  final String? uid;
  final String? initialName;
  final String? initialEmployeeId;
  final String? initialEmail;
  final String? initialPhone;
  final String? initialDepartment;
  final String? initialRole;
  final String? initialEmploymentStatus;
  final String? initialAddress;
  final DateTime? initialStartDate;

  const EditProfileScreen({
    super.key,
    this.uid,
    this.initialName,
    this.initialEmployeeId,
    this.initialEmail,
    this.initialPhone,
    this.initialDepartment,
    this.initialRole,
    this.initialEmploymentStatus,
    this.initialAddress,
    this.initialStartDate,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _employeeIdController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _departmentController;
  late final TextEditingController _roleController;
  late final TextEditingController _addressController;

  static const List<String> _statusOptions = <String>[
    'Karyawan Tetap',
    'Karyawan Kontrak (PKWT)',
    'Pekerja Harian / Lepas',
    'Magang / PKL',
  ];

  late String _selectedStatus;
  late DateTime _selectedStartDate;
  bool _isSaving = false;
  String? _targetUid;

  @override
  void initState() {
    super.initState();
    _targetUid = widget.uid ?? FirebaseAuth.instance.currentUser?.uid;
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _employeeIdController =
        TextEditingController(text: widget.initialEmployeeId ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _phoneController = TextEditingController(text: widget.initialPhone ?? '');
    _departmentController =
        TextEditingController(text: widget.initialDepartment ?? '');
    _roleController =
        TextEditingController(text: widget.initialRole ?? 'Staf / Karyawan');
    _addressController =
        TextEditingController(text: widget.initialAddress ?? '');

    _selectedStatus =
        _statusOptions.contains(widget.initialEmploymentStatus)
            ? widget.initialEmploymentStatus!
            : _statusOptions.first;

    _selectedStartDate = widget.initialStartDate ?? DateTime(2026, 11, 22);

    _loadExistingProfileData();
  }

  Future<void> _loadExistingProfileData() async {
    final String? uid = _targetUid;
    if (uid == null || uid.isEmpty) return;

    final DataSnapshot snap =
        await FirebaseDatabase.instance.ref('matrix_members/$uid').get();
    if (!snap.exists || snap.value is! Map || !mounted) return;

    final Map<dynamic, dynamic> data = snap.value as Map<dynamic, dynamic>;

    setState(() {
      if (_nameController.text.trim().isEmpty && data['name'] != null) {
        _nameController.text = data['name'].toString();
      }
      if (_employeeIdController.text.trim().isEmpty &&
          data['employeeId'] != null) {
        _employeeIdController.text = data['employeeId'].toString();
      }
      if (_emailController.text.trim().isEmpty && data['email'] != null) {
        _emailController.text = data['email'].toString();
      }
      if (_phoneController.text.trim().isEmpty && data['phone'] != null) {
        _phoneController.text = data['phone'].toString();
      }
      if (_departmentController.text.trim().isEmpty &&
          data['department'] != null) {
        _departmentController.text = data['department'].toString();
      }
      if (data['role'] != null && data['role'].toString().trim().isNotEmpty) {
        _roleController.text = data['role'].toString();
      }
      if (_addressController.text.trim().isEmpty && data['address'] != null) {
        _addressController.text = data['address'].toString();
      }
      if (data['employmentStatus'] != null &&
          _statusOptions.contains(data['employmentStatus'].toString())) {
        _selectedStatus = data['employmentStatus'].toString();
      }
      if (widget.initialStartDate == null && data['startDate'] != null) {
        final DateTime? parsed = parseIsoDate(data['startDate'].toString());
        if (parsed != null) {
          _selectedStartDate = parsed;
        }
      }
    });
  }

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime(2035, 12, 31),
      helpText: 'Pilih Tanggal Mulai Bekerja',
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final String? uid = _targetUid;
    if (uid == null || uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('UID pengguna tidak ditemukan.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1. Simpan tanggal mulai bekerja ke matrix_members/$uid
      await setUserStartDate(
        uid: uid,
        startDate: _selectedStartDate,
      );

      // 2. Simpan informasi profil & kepegawaian ke matrix_members/$uid
      await FirebaseDatabase.instance
          .ref('matrix_members/$uid')
          .update(<String, dynamic>{
        'name': _nameController.text.trim(),
        'employeeId': _employeeIdController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'department': _departmentController.text.trim(),
        'role': _roleController.text.trim(),
        'employmentStatus': _selectedStatus,
        'address': _addressController.text.trim(),
        'updatedAt': ServerValue.timestamp,
      });

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan profil: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _roleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil & Data Pekerja'),
        actions: [
          IconButton(
            tooltip: 'Simpan',
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            onPressed: _isSaving ? null : _saveProfile,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Data Kepegawaian',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _employeeIdController,
              decoration: const InputDecoration(
                labelText: 'NIP / ID Karyawan',
                hintText: 'Contoh: EMP-2026-001',
                prefixIcon: Icon(Icons.badge_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _departmentController,
              decoration: const InputDecoration(
                labelText: 'Departemen / Divisi',
                hintText: 'Contoh: Operasional / Teknisi / IT',
                prefixIcon: Icon(Icons.apartment_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _roleController,
              decoration: const InputDecoration(
                labelText: 'Jabatan / Peran',
                prefixIcon: Icon(Icons.work_outline),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Jabatan wajib diisi'
                  : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status Kepegawaian',
                prefixIcon: Icon(Icons.assignment_ind_outlined),
                border: OutlineInputBorder(),
              ),
              items: _statusOptions
                  .map(
                    (status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: _pickStartDate,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Mulai Bekerja',
                  prefixIcon: Icon(Icons.event_available_outlined),
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatIndonesianDate(_selectedStartDate),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Format sistem: ${formatDateToIso(_selectedStartDate)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: _pickStartDate,
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text('Ubah'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Informasi Pribadi & Kontak',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'No. Telepon / WhatsApp',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Alamat Domisili',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveProfile,
              icon: const Icon(Icons.save_outlined),
              label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Data Pekerja'),
            ),
          ],
        ),
      ),
    );
  }
}