import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'models/company_profile_model.dart';
import 'package:matrix_sphere/screens/attendance/services/attendance_location_service.dart';
import 'package:matrix_sphere/screens/attendance/widgets/location_pin_lock_dialog.dart';

class EditCompanyPage extends StatefulWidget {
  final CompanyProfileModel? initialCompany;

  const EditCompanyPage({super.key, this.initialCompany});

  @override
  State<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  static const String _permanentAdminUid = 'mjS1Y9Ll3JRQCMGSTK2oIBVIHT22';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference _companyRef = FirebaseDatabase.instance.ref(
    'company_profile',
  );
  final AttendanceLocationService _locationService =
      AttendanceLocationService();

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

  final String _locationPin = '123456';
  bool _isAttendanceEnabled = true;
  bool _isCheckingAdmin = true;
  bool _isAdmin = false;
  bool _isSaving = false;
  // PIN bisa dibaca dari company_profile (misal data['locationPin']) dengan fallback aman
  bool _isFetchingLocation = false;

  Future<void> _pickCurrentLocationWithPinLock() async {
    if (_isFetchingLocation) return;

    final bool pinValid = await LocationPinLockDialog.verify(
      context,
      expectedPin: _locationPin,
      title: 'PIN Lock Pengambilan Lokasi',
      subtitle:
          'Masukkan PIN untuk mengambil koordinat GPS titik kantor saat ini.',
    );

    if (!pinValid || !mounted) return;

    setState(() => _isFetchingLocation = true);
    try {
      final AttendanceLocationData loc = await _locationService
          .getCurrentLocation();
      if (!mounted) return;

      _latitudeController.text = loc.latitude.toStringAsFixed(6);
      _longitudeController.text = loc.longitude.toStringAsFixed(6);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lokasi berhasil diambil (${loc.latitude.toStringAsFixed(6)}, ${loc.longitude.toStringAsFixed(6)}).',
          ),
        ),
      );
    } on AttendanceLocationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil lokasi: $e')));
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

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

    final DataSnapshot snapshot = await _companyRef.get();
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
      if (data['isAttendanceEnabled'] is bool) {
        _isAttendanceEnabled = data['isAttendanceEnabled'] as bool;
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

    setState(() => _isSaving = true);

    try {
      await _companyRef.update({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'description': _descriptionController.text.trim(),
        'matrixSphereWorkStart': _matrixStartController.text.trim(),
        'matrixSphereWorkEnd': _matrixEndController.text.trim(),
        'latitude': lat,
        'longitude': lng,
        'radiusMeters': radius,
        'isAttendanceEnabled': _isAttendanceEnabled,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profil, jam kerja & lokasi absensi berhasil disimpan.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan perubahan: $e')));
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
            const SizedBox(height: 24),
            Text(
              'Lokasi & Radius Absensi',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
            if (_isAdmin) const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _isFetchingLocation
                  ? null
                  : _pickCurrentLocationWithPinLock,
              icon: _isFetchingLocation
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                _isFetchingLocation
                    ? 'Mengambil Koordinat GPS...'
                    : 'Ambil Lokasi Saat Ini (PIN Lock)',
              ),
            ),
            FilledButton(
              onPressed: _isSaving ? null : _saveCompanyChanges,
              child: Text(_isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
