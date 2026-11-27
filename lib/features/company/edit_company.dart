import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import 'logic/company_profile_logic.dart';
import 'services/company_service.dart';
import 'ui/form/company_profile_form_controller.dart';

class EditCompanyScreen extends StatefulWidget {
  const EditCompanyScreen({super.key});

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  late final CompanyProfileLogic _logic;
  late final Future<bool> _adminFuture;
  late final CompanyProfileFormController _form;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _logic = CompanyProfileLogic();
    _adminFuture = _logic.isAdmin();
    _form = CompanyProfileFormController();
    _logic.logScreenOpen('edit_company_profile');
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_form.formKey.currentState!.validate() || _isSaving) return;

    setState(() => _isSaving = true);
    try {
      await _logic.saveProfile(_form.toPayload());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil perusahaan berhasil disimpan.')),
      );
      Navigator.of(context).pop(true);
    } catch (e, stack) {
      await crashlyticsService.recordError(
        e,
        stack,
        reason: 'EditCompanyScreen._onSave',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan profil: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _adminFuture,
      builder: (context, adminSnapshot) {
        if (adminSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bool isAdmin = adminSnapshot.data ?? false;
        if (!isAdmin) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Profil Perusahaan')),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Akses ditolak. Halaman ini hanya tersedia untuk Admin.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profil Perusahaan'),
            actions: [
              TextButton(
                onPressed: _isSaving ? null : _onSave,
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan'),
              ),
            ],
          ),
          body: StreamBuilder<CompanyProfileBundle>(
            stream: _logic.companyStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !_form.isPopulated) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                _form.populateFromBundle(
                  snapshot.data!.company,
                  snapshot.data!.attendanceRule,
                );
              }

              return Form(
                key: _form.formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
                  children: [
                    Text(
                      'Informasi Perusahaan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _form.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Perusahaan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _form.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _form.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Telepon',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _form.addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _form.logoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL Logo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _form.descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Jam Kerja, Lokasi & Aturan Absensi',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _form.workStartController,
                            decoration: const InputDecoration(
                              labelText: 'Jam Mulai (HH:mm)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _form.workEndController,
                            decoration: const InputDecoration(
                              labelText: 'Jam Selesai (HH:mm)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _form.graceMinutesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Toleransi Terlambat (menit)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _form.latitudeController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _form.longitudeController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _form.radiusController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Radius Absensi (meter)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _form.photoType,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Kamera / Foto',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'front_selfie',
                          child: Text('Kamera Depan (Selfie)'),
                        ),
                        DropdownMenuItem(
                          value: 'rear_site',
                          child: Text('Kamera Belakang (Bukti Lokasi/Kerja)'),
                        ),
                        DropdownMenuItem(
                          value: 'both',
                          child: Text('Kamera Depan & Belakang'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _form.photoType = val);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
