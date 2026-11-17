import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:matrix_sphere/features/profile/services/profile_image_service.dart';

class EditCompanyProfile extends StatefulWidget {
  const EditCompanyProfile({super.key});

  @override
  State<EditCompanyProfile> createState() =>
      _EditCompanyProfileState();
}

class _EditCompanyProfileState extends State<EditCompanyProfile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _taglineController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _selectedLogoFile;
  String? _currentLogoUrl;
  bool _isLoading = false;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  Future<void> _loadCompanyData() async {
    try {
      final snapshot =
          await FirebaseDatabase.instance.ref('company_profile').get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        _nameController.text = data['name']?.toString() ?? '';
        _taglineController.text = data['tagline']?.toString() ?? '';
        _industryController.text = data['industry']?.toString() ?? '';
        _emailController.text = data['email']?.toString() ?? '';
        _phoneController.text = data['phone']?.toString() ?? '';
        _websiteController.text = data['website']?.toString() ?? '';
        _addressController.text = data['address']?.toString() ?? '';
        _currentLogoUrl = data['logoUrl']?.toString();
      }
    } catch (e) {
      debugPrint('Gagal memuat data perusahaan: $e');
    } finally {
      if (mounted) {
        setState(() => _isInitialLoading = false);
      }
    }
  }

  Future<void> _handlePickLogo() async {
    final imageFile = await ProfileImageService.pickAndCompressImage();
    if (imageFile != null) {
      setState(() => _selectedLogoFile = imageFile);
    }
  }

  Future<void> _saveCompanyProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? finalLogoUrl = _currentLogoUrl;

      // Unggah logo baru ke ImgBB jika dipilih
      if (_selectedLogoFile != null) {
        final uploadedUrl =
            await ProfileImageService.uploadImageToImgBB(_selectedLogoFile!);
        if (uploadedUrl != null) {
          finalLogoUrl = uploadedUrl;
        } else {
          throw Exception('Gagal mengunggah logo perusahaan ke ImgBB.');
        }
      }

      // Simpan ke node company_profile di RTDB
      await FirebaseDatabase.instance.ref('company_profile').update({
        'name': _nameController.text.trim(),
        'tagline': _taglineController.text.trim(),
        'industry': _industryController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'website': _websiteController.text.trim(),
        'address': _addressController.text.trim(),
        'logoUrl': finalLogoUrl ?? '',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil perusahaan berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );

      AppNavigation.goBack(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan (Pastikan akun Anda Admin): $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _industryController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil Perusahaan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.goBack(context),
        ),
      ),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Pemilih Logo Perusahaan
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.blue.shade200, width: 2),
                            image: _selectedLogoFile != null
                                ? DecorationImage(
                                    image: FileImage(_selectedLogoFile!),
                                    fit: BoxFit.cover,
                                  )
                                : (_currentLogoUrl != null &&
                                        _currentLogoUrl!.isNotEmpty)
                                    ? DecorationImage(
                                        image: NetworkImage(_currentLogoUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                          ),
                          child: (_selectedLogoFile == null &&
                                  (_currentLogoUrl == null ||
                                      _currentLogoUrl!.isEmpty))
                              ? const Icon(Icons.apartment,
                                  size: 56, color: Colors.blue)
                              : null,
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                size: 18, color: Colors.white),
                            onPressed: _isLoading ? null : _handlePickLogo,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ketuk ikon kamera untuk mengganti logo perusahaan',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Perusahaan',
                        prefixIcon: Icon(Icons.apartment),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Nama perusahaan wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _taglineController,
                      decoration: const InputDecoration(
                        labelText: 'Slogan / Tagline',
                        prefixIcon: Icon(Icons.format_quote),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _industryController,
                      decoration: const InputDecoration(
                        labelText: 'Bidang Usaha',
                        prefixIcon: Icon(Icons.business_center_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Resmi',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Telepon / WhatsApp Kantor',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _websiteController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Website',
                        prefixIcon: Icon(Icons.language),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Alamat Kantor Pusat',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _isLoading
                              ? 'Menyimpan Data...'
                              : 'Simpan Profil Perusahaan',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isLoading ? null : _saveCompanyProfile,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}