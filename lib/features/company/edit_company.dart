import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import 'models/company_profile_model.dart';

class EditCompanyPage extends StatefulWidget {
  final CompanyProfileModel? initialCompany;

  const EditCompanyPage({super.key, this.initialCompany});

  @override
  State<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  static const String _permanentAdminUid = 'mjS1Y9Ll3JRQCMGSTK2oIBVIHT22';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _matrixStartController;
  late final TextEditingController _matrixEndController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _radiusMetersController;
  late final TextEditingController _graceMinutesController;

  // Controller Dekrit & Jam Lembur
  late final TextEditingController _decreeNumberController;
  late final TextEditingController _decreeNoteController;
  late final TextEditingController _weekdayOvertimeEndController;
  late final TextEditingController _saturdayStartController;
  late final TextEditingController _saturdayEndController;
  late final TextEditingController _sundayStartController;
  late final TextEditingController _sundayEndController;

  static const Map<String, String> _photoTypeOptions = <String, String>{
    'front_selfie': 'Kamera Depan (Selfie)',
    'rear_site': 'Kamera Belakang (Bukti Lokasi/Kerja)',
    'both': 'Kamera Depan & Belakang',
  };

  bool _isAttendanceEnabled = true;
  bool _requireLocationAttendance = true;
  bool _requirePhotoAttendance = true;
  bool _allowOutsideRadius = false;
  String _selectedPhotoType = 'front_selfie';

  // Toggle Dekrit & Lembur
  bool _overtimeDecreeEnabled = false;
  bool _allowWeekdayOvertime = true;
  bool _allowSaturdayOvertime = true;
  bool _allowSundayOvertime = true;

  bool _isCheckingAdmin = true;
  bool _isAdmin = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final CompanyProfileModel? c = widget.initialCompany;
    _nameController = TextEditingController(text: c?.name ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _descriptionController = TextEditingController(text: c?.description ?? '');
    _matrixStartController = TextEditingController(text: '08:00');
    _matrixEndController = TextEditingController(text: '17:00');
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _radiusMetersController = TextEditingController(text: '100');
    _graceMinutesController = TextEditingController(text: '15');

    _decreeNumberController = TextEditingController();
    _decreeNoteController = TextEditingController(
      text:
          'Pekerja diperbolehkan melaksanakan lembur setelah jam kerja maupun pada hari Sabtu & Minggu sesuai dekrit resmi Matrix Sphere.',
    );
    _weekdayOvertimeEndController = TextEditingController(text: '21:00');
    _saturdayStartController = TextEditingController(text: '08:00');
    _saturdayEndController = TextEditingController(text: '17:00');
    _sundayStartController = TextEditingController(text: '08:00');
    _sundayEndController = TextEditingController(text: '17:00');

    _verifyAdminAndLoadData();
  }

  String _readTextOrDefault(
    Map<dynamic, dynamic> data,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final String key in keys) {
      final dynamic val = data[key];
      if (val != null && val.toString().trim().isNotEmpty) {
        return val.toString().trim();
      }
    }
    return fallback;
  }

  bool _parseBool(dynamic value, {required bool fallback}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final String lower = value.toString().trim().toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
    return fallback;
  }

  Future<void> _verifyAdminAndLoadData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    bool adminAccess = false;

    if (user != null) {
      if (user.uid == _permanentAdminUid) {
        adminAccess = true;
      } else {
        final IdTokenResult tokenResult = await user.getIdTokenResult(true);
        final Map<String, dynamic>? claims = tokenResult.claims;
        adminAccess = claims?['admin'] == true || claims?['isAdmin'] == true;
      }
    }

    final DataSnapshot snapshot = await rtdbService.getSnapshot(
      'company_profile',
    );
    if (snapshot.exists && snapshot.value is Map) {
      final Map<dynamic, dynamic> data =
          snapshot.value as Map<dynamic, dynamic>;
      if (widget.initialCompany == null) {
        _nameController.text = data['name']?.toString() ?? _nameController.text;
        _emailController.text =
            data['email']?.toString() ?? _emailController.text;
        _phoneController.text =
            data['phone']?.toString() ?? _phoneController.text;
        _addressController.text =
            data['address']?.toString() ?? _addressController.text;
        _descriptionController.text =
            data['description']?.toString() ?? _descriptionController.text;
      }
      _matrixStartController.text =
          data['matrixSphereWorkStart']?.toString() ?? '08:00';
      _matrixEndController.text =
          data['matrixSphereWorkEnd']?.toString() ?? '17:00';
      _latitudeController.text = _readTextOrDefault(data, ['latitude', 'lat']);
      _longitudeController.text = _readTextOrDefault(data, [
        'longitude',
        'lng',
      ]);
      _radiusMetersController.text = _readTextOrDefault(data, [
        'radiusMeters',
        'radius_meters',
        'radius',
        'attendanceRadius',
      ], fallback: '100');
      _graceMinutesController.text = _readTextOrDefault(data, [
        'graceMinutes',
        'grace_minutes',
      ], fallback: '15');

      _isAttendanceEnabled = _parseBool(
        data['isAttendanceEnabled'],
        fallback: true,
      );
      _requireLocationAttendance = _parseBool(
        data['requireLocationAttendance'],
        fallback: true,
      );
      _requirePhotoAttendance = _parseBool(
        data['requirePhotoAttendance'],
        fallback: true,
      );
      _allowOutsideRadius = _parseBool(
        data['allowOutsideRadius'],
        fallback: false,
      );

      // Muat data dekrit & jam lembur
      _overtimeDecreeEnabled = _parseBool(
        data['overtimeDecreeEnabled'],
        fallback: false,
      );
      _decreeNumberController.text = _readTextOrDefault(data, [
        'overtimeDecreeNumber',
      ]);
      _decreeNoteController.text = _readTextOrDefault(
        data,
        ['overtimeDecreeNote'],
        fallback: _decreeNoteController.text,
      );
      _allowWeekdayOvertime = _parseBool(
        data['allowWeekdayOvertime'],
        fallback: true,
      );
      _weekdayOvertimeEndController.text = _readTextOrDefault(
        data,
        ['weekdayOvertimeEnd'],
        fallback: '21:00',
      );
      _allowSaturdayOvertime = _parseBool(
        data['allowSaturdayOvertime'],
        fallback: true,
      );
      _saturdayStartController.text = _readTextOrDefault(
        data,
        ['saturdayOvertimeStart'],
        fallback: '08:00',
      );
      _saturdayEndController.text = _readTextOrDefault(
        data,
        ['saturdayOvertimeEnd'],
        fallback: '17:00',
      );
      _allowSundayOvertime = _parseBool(
        data['allowSundayOvertime'],
        fallback: true,
      );
      _sundayStartController.text = _readTextOrDefault(
        data,
        ['sundayOvertimeStart'],
        fallback: '08:00',
      );
      _sundayEndController.text = _readTextOrDefault(
        data,
        ['sundayOvertimeEnd'],
        fallback: '17:00',
      );

      final String rawPhotoType =
          data['photoType']?.toString().trim() ?? 'front_selfie';
      if (_photoTypeOptions.containsKey(rawPhotoType)) {
        _selectedPhotoType = rawPhotoType;
      }
    }

    if (!mounted) return;
    setState(() {
      _isAdmin = adminAccess;
      _isCheckingAdmin = false;
    });
  }

  Future<void> _saveCompanyChanges() async {
    if (!_isAdmin || _isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final double? lat = double.tryParse(_latitudeController.text.trim());
    final double? lng = double.tryParse(_longitudeController.text.trim());
    final double? radius = double.tryParse(_radiusMetersController.text.trim());
    final int graceMinutes =
        int.tryParse(_graceMinutesController.text.trim()) ?? 15;

    setState(() => _isSaving = true);

    try {
      await rtdbService.updateData(
        'company_profile',
        <String, Object?>{
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'description': _descriptionController.text.trim(),
          // Hari kerja reguler Senin - Jumat (1..5)
          'workDays': <int>[1, 2, 3, 4, 5],
          'matrixSphereWorkStart': _matrixStartController.text.trim(),
          'matrixSphereWorkEnd': _matrixEndController.text.trim(),
          'latitude': lat,
          'longitude': lng,
          'radiusMeters': radius,
          'graceMinutes': graceMinutes,
          'isAttendanceEnabled': _isAttendanceEnabled,
          'requireLocationAttendance': _requireLocationAttendance,
          'requirePhotoAttendance': _requirePhotoAttendance,
          'allowOutsideRadius': _allowOutsideRadius,
          'photoType': _selectedPhotoType,
          // Dekrit & Jadwal Lembur Matrix Sphere
          'overtimeDecreeEnabled': _overtimeDecreeEnabled,
          'overtimeDecreeNumber': _decreeNumberController.text.trim(),
          'overtimeDecreeNote': _decreeNoteController.text.trim(),
          'allowWeekdayOvertime': _allowWeekdayOvertime,
          'weekdayOvertimeEnd': _weekdayOvertimeEndController.text.trim(),
          'allowSaturdayOvertime': _allowSaturdayOvertime,
          'saturdayOvertimeStart': _saturdayStartController.text.trim(),
          'saturdayOvertimeEnd': _saturdayEndController.text.trim(),
          'allowSundayOvertime': _allowSundayOvertime,
          'sundayOvertimeStart': _sundayStartController.text.trim(),
          'sundayOvertimeEnd': _sundayEndController.text.trim(),
          'overtimeUpdatedAt': ServerValue.timestamp,
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profil, jadwal Senin-Jumat & dekrit lembur berhasil disimpan.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e, stack) {
      await rtdbService.logAppError(
        source: 'EditCompanyPage._saveCompanyChanges',
        error: e,
        stackTrace: stack,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan perubahan: $e')),
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
    _addressController.dispose();
    _descriptionController.dispose();
    _matrixStartController.dispose();
    _matrixEndController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _radiusMetersController.dispose();
    _graceMinutesController.dispose();
    _decreeNumberController.dispose();
    _decreeNoteController.dispose();
    _weekdayOvertimeEndController.dispose();
    _saturdayStartController.dispose();
    _saturdayEndController.dispose();
    _sundayStartController.dispose();
    _sundayEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAdmin) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil Perusahaan'),
        actions: [
          if (_isAdmin)
            IconButton(
              tooltip: 'Simpan',
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              onPressed: _isSaving ? null : _saveCompanyChanges,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (!_isAdmin)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Mode lihat saja: hanya Admin yang dapat mengubah data dan jam kerja.',
                ),
              ),
            TextFormField(
              controller: _nameController,
              readOnly: !_isAdmin,
              decoration: const InputDecoration(labelText: 'Nama Perusahaan'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              readOnly: !_isAdmin,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              readOnly: !_isAdmin,
              decoration: const InputDecoration(labelText: 'Telepon'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              readOnly: !_isAdmin,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              readOnly: !_isAdmin,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 24),
            Text(
              'Jam Kerja Reguler (Senin - Jumat)',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _matrixStartController,
                    readOnly: !_isAdmin,
                    decoration: const InputDecoration(
                      labelText: 'Jam Mulai (HH:mm)',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _matrixEndController,
                    readOnly: !_isAdmin,
                    decoration: const InputDecoration(
                      labelText: 'Jam Selesai (HH:mm)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _graceMinutesController,
              readOnly: !_isAdmin,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Toleransi Keterlambatan (menit)',
                hintText: 'Contoh: 15',
              ),
              validator: (v) {
                final int? val = int.tryParse(v?.trim() ?? '');
                if (val == null || val < 0) {
                  return 'Masukkan angka >= 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Dekrit & Kebijakan Lembur Matrix Sphere',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aktifkan Dekrit Lembur Pekerja'),
              subtitle: const Text(
                'Mengizinkan pekerja lembur setelah jam kerja maupun akhir pekan',
              ),
              value: _overtimeDecreeEnabled,
              onChanged: _isAdmin
                  ? (val) => setState(() => _overtimeDecreeEnabled = val)
                  : null,
            ),
            if (_overtimeDecreeEnabled) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _decreeNumberController,
                readOnly: !_isAdmin,
                decoration: const InputDecoration(
                  labelText: 'Nomor / Kode Dekrit Lembur',
                  hintText: 'Contoh: SK-MS/OT/2026/01',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _decreeNoteController,
                readOnly: !_isAdmin,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Keterangan Dekrit Lembur',
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Lembur Hari Kerja (Senin - Jumat)'),
                subtitle: const Text('Berlaku setelah jam selesai kerja reguler'),
                value: _allowWeekdayOvertime,
                onChanged: _isAdmin
                    ? (val) => setState(() => _allowWeekdayOvertime = val)
                    : null,
              ),
              if (_allowWeekdayOvertime)
                TextFormField(
                  controller: _weekdayOvertimeEndController,
                  readOnly: !_isAdmin,
                  decoration: const InputDecoration(
                    labelText: 'Batas Akhir Lembur Senin - Jumat (HH:mm)',
                    hintText: 'Contoh: 21:00',
                  ),
                ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Lembur Hari Sabtu'),
                value: _allowSaturdayOvertime,
                onChanged: _isAdmin
                    ? (val) => setState(() => _allowSaturdayOvertime = val)
                    : null,
              ),
              if (_allowSaturdayOvertime)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _saturdayStartController,
                        readOnly: !_isAdmin,
                        decoration: const InputDecoration(
                          labelText: 'Mulai Sabtu (HH:mm)',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _saturdayEndController,
                        readOnly: !_isAdmin,
                        decoration: const InputDecoration(
                          labelText: 'Selesai Sabtu (HH:mm)',
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Lembur Hari Minggu'),
                value: _allowSundayOvertime,
                onChanged: _isAdmin
                    ? (val) => setState(() => _allowSundayOvertime = val)
                    : null,
              ),
              if (_allowSundayOvertime)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _sundayStartController,
                        readOnly: !_isAdmin,
                        decoration: const InputDecoration(
                          labelText: 'Mulai Minggu (HH:mm)',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _sundayEndController,
                        readOnly: !_isAdmin,
                        decoration: const InputDecoration(
                          labelText: 'Selesai Minggu (HH:mm)',
                        ),
                      ),
                    ),
                  ],
                ),
            ],
            const SizedBox(height: 24),
            Text(
              'Lokasi & Radius Absensi',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latitudeController,
                    readOnly: !_isAdmin,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Latitude (contoh: -6.200000)',
                    ),
                    validator: (v) {
                      final String raw = v?.trim() ?? '';
                      if (raw.isEmpty) return 'Latitude wajib diisi';
                      final double? parsed = double.tryParse(raw);
                      if (parsed == null || parsed < -90 || parsed > 90) {
                        return 'Latitude tidak valid (-90 s.d. 90)';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _longitudeController,
                    readOnly: !_isAdmin,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Longitude (contoh: 106.816666)',
                    ),
                    validator: (v) {
                      final String raw = v?.trim() ?? '';
                      if (raw.isEmpty) return 'Longitude wajib diisi';
                      final double? parsed = double.tryParse(raw);
                      if (parsed == null || parsed < -180 || parsed > 180) {
                        return 'Longitude tidak valid (-180 s.d. 180)';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _radiusMetersController,
              readOnly: !_isAdmin,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Radius Absensi (meter)',
                hintText: 'Contoh: 100',
              ),
              validator: (v) {
                final String raw = v?.trim() ?? '';
                if (raw.isEmpty) return 'Radius wajib diisi';
                final double? parsed = double.tryParse(raw);
                if (parsed == null || parsed <= 0) {
                  return 'Radius harus lebih dari 0 meter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Kebutuhan Lokasi & Kamera Absensi',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aktifkan Absensi Karyawan'),
              value: _isAttendanceEnabled,
              onChanged: _isAdmin
                  ? (val) => setState(() => _isAttendanceEnabled = val)
                  : null,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Wajibkan Koordinat Lokasi (GPS)'),
              value: _requireLocationAttendance,
              onChanged: _isAdmin
                  ? (val) => setState(() => _requireLocationAttendance = val)
                  : null,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Izinkan Absen di Luar Radius (Perlu Review)'),
              value: _allowOutsideRadius,
              onChanged: (_isAdmin && _requireLocationAttendance)
                  ? (val) => setState(() => _allowOutsideRadius = val)
                  : null,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Wajibkan Bukti Foto Kamera'),
              value: _requirePhotoAttendance,
              onChanged: _isAdmin
                  ? (val) => setState(() => _requirePhotoAttendance = val)
                  : null,
            ),
            if (_requirePhotoAttendance) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedPhotoType,
                decoration: const InputDecoration(
                  labelText: 'Jenis Kamera / Bukti Foto',
                  border: OutlineInputBorder(),
                ),
                items: _photoTypeOptions.entries
                    .map(
                      (entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: _isAdmin
                    ? (val) {
                        if (val != null) {
                          setState(() => _selectedPhotoType = val);
                        }
                      }
                    : null,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: (_isAdmin && !_isSaving) ? _saveCompanyChanges : null,
              child: Text(_isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}