// lib/features/profile/edit_profile.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/screens/attendance/helpers/work_schedule_helper.dart';

/// Menyimpan tanggal mulai bekerja user (`startDate` format YYYY-MM-DD)
/// ke node RTDB `attendance/matrix/$uid`.
Future<void> setUserStartDate({
  required String uid,
  required DateTime startDate,
}) async {
  final String formattedStartDate = WorkScheduleHelper.toDateKey(startDate);
  await FirebaseDatabase.instance
      .ref('attendance/matrix/$uid')
      .update(<String, dynamic>{
    'startDate': formattedStartDate,
  });
}

class EditProfileScreen extends StatefulWidget {
  final String? uid;
  final String? initialName;
  final String? initialEmail;
  final String? initialPhone;
  final String? initialRole;
  final DateTime? initialStartDate;

  const EditProfileScreen({
    super.key,
    this.uid,
    this.initialName,
    this.initialEmail,
    this.initialPhone,
    this.initialRole,
    this.initialStartDate,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _roleController;

  // Default tanggal mulai bekerja 22-11-2026 (2026-11-22)
  late DateTime _selectedStartDate;
  bool _isSaving = false;
  String? _targetUid;

  @override
  void initState() {
    super.initState();
    _targetUid = widget.uid ?? FirebaseAuth.instance.currentUser?.uid;
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _phoneController = TextEditingController(text: widget.initialPhone ?? '');
    _roleController =
        TextEditingController(text: widget.initialRole ?? 'Staf / Karyawan');
    _selectedStartDate = widget.initialStartDate ?? DateTime(2026, 11, 22);

    _loadExistingProfileData();
  }

  Future<void> _loadExistingProfileData() async {
    final String? uid = _targetUid;
    if (uid == null || uid.isEmpty) return;

    final DataSnapshot snap =
        await FirebaseDatabase.instance.ref('attendance/matrix/$uid').get();
    if (!snap.exists || snap.value is! Map || !mounted) return;

    final Map<dynamic, dynamic> data = snap.value as Map<dynamic, dynamic>;
    final DateTime? parsedStart = WorkScheduleHelper.parseDate(
      data['startDate'] ?? data['start_date'],
    );

    setState(() {
      if (_nameController.text.trim().isEmpty && data['name'] != null) {
        _nameController.text = data['name'].toString();
      }
      if (_emailController.text.trim().isEmpty && data['email'] != null) {
        _emailController.text = data['email'].toString();
      }
      if (_phoneController.text.trim().isEmpty && data['phone'] != null) {
        _phoneController.text = data['phone'].toString();
      }
      if (data['role'] != null && data['role'].toString().trim().isNotEmpty) {
        _roleController.text = data['role'].toString();
      }
      if (parsedStart != null) {
        _selectedStartDate = parsedStart;
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
      // 1. Simpan tanggal mulai bekerja ke attendance/matrix/$uid
      await setUserStartDate(
        uid: uid,
        startDate: _selectedStartDate,
      );

      // 2. Simpan informasi profil pendukung ke attendance/matrix/$uid
      await FirebaseDatabase.instance
          .ref('attendance/matrix/$uid')
          .update(<String, dynamic>{
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'role': _roleController.text.trim(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profil & tanggal mulai bekerja (${WorkScheduleHelper.toDateKey(_selectedStartDate)}) tersimpan.',
          ),
        ),
      );
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
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = WorkScheduleHelper.toDateKey(_selectedStartDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil Pengguna'),
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _roleController,
              decoration: const InputDecoration(
                labelText: 'Jabatan / Peran',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'No. Telepon',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Tanggal Mulai Bekerja (startDate)',
                border: OutlineInputBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _pickStartDate,
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text('Pilih Tanggal'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: Text(_isSaving ? 'Menyimpan...' : 'Simpan Profil'),
            ),
          ],
        ),
      ),
    );
  }
}