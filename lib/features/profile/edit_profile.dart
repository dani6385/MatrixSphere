// lib/screens/profile/edit_profile.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:matrix_sphere/navigations/app_navigation.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // GANTI DENGAN API KEY IMGBB MILIKMU (Dapatkan gratis di api.imgbb.com)
  static const String _imgbbApiKey = 'f601727fed32cf7a175833d01d8a10ff';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _selectedImageFile;
  String? _currentPhotoUrl;
  bool _isLoading = false;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  /// Mengambil data profil saat ini dari Firebase Auth & RTDB untuk mengisi form
  Future<void> _loadCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot =
          await FirebaseDatabase.instance.ref('users/${user.uid}').get();

      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        _nameController.text =
            data['name']?.toString() ?? user.displayName ?? '';
        _phoneController.text = data['phone']?.toString() ?? '';
        _roleController.text = data['role']?.toString() ?? '';
        _addressController.text = data['address']?.toString() ?? '';
        _currentPhotoUrl = data['photoUrl']?.toString() ?? user.photoURL;
      } else {
        _nameController.text = user.displayName ?? '';
        _currentPhotoUrl = user.photoURL;
      }
    } catch (e) {
      debugPrint('Gagal memuat data profil: $e');
    } finally {
      if (mounted) {
        setState(() => _isInitialLoading = false);
      }
    }
  }

  /// Memilih gambar dari galeri sekaligus mengompresi ukuran & resolusinya
  Future<void> _pickAndCompressImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      // KOMPRESI OTOMATIS: Batasi dimensi maks 512x512 px dan kualitas 70%
      // Ukuran file 3MB akan otomatis menyusut menjadi sekitar 30KB - 60KB!
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  /// Mengunggah file gambar terkompresi ke ImgBB dan mengembalikan URL-nya
  Future<String?> _uploadImageToImgBB(File imageFile) async {
    try {
      final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$_imgbbApiKey');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data']['url'] as String?;
      } else {
        debugPrint('ImgBB Upload Gagal (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error upload ImgBB: $e');
      return null;
    }
  }

  /// Menyimpan seluruh perubahan profil ke ImgBB, Firebase Auth, dan RTDB
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      String? finalPhotoUrl = _currentPhotoUrl;

      // 1. Jika pengguna memilih foto baru, unggah ke ImgBB terlebih dahulu
      if (_selectedImageFile != null) {
        final uploadedUrl = await _uploadImageToImgBB(_selectedImageFile!);
        if (uploadedUrl != null) {
          finalPhotoUrl = uploadedUrl;
        } else {
          throw Exception('Gagal mengunggah foto ke ImgBB. Periksa API Key atau koneksi internet.');
        }
      }

      final String newName = _nameController.text.trim();

      // 2. Perbarui profil dasar di Firebase Auth
      await user.updateDisplayName(newName);
      if (finalPhotoUrl != null && finalPhotoUrl.isNotEmpty) {
        await user.updatePhotoURL(finalPhotoUrl);
      }

      // 3. Simpan data pribadi lengkap ke Firebase Realtime Database
      await FirebaseDatabase.instance.ref('users/${user.uid}').update({
        'uid': user.uid,
        'email': user.email,
        'name': newName,
        'phone': _phoneController.text.trim(),
        'role': _roleController.text.trim(),
        'address': _addressController.text.trim(),
        'photoUrl': finalPhotoUrl ?? '',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke halaman User Profile
      AppNavigation.goBack(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
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
    _phoneController.dispose();
    _roleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
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
                    // Pemilih Foto Profil dengan Pratinjau Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.blue.shade100,
                          backgroundImage: _selectedImageFile != null
                              ? FileImage(_selectedImageFile!) as ImageProvider
                              : (_currentPhotoUrl != null &&
                                      _currentPhotoUrl!.isNotEmpty)
                                  ? NetworkImage(_currentPhotoUrl!)
                                  : null,
                          child: (_selectedImageFile == null &&
                                  (_currentPhotoUrl == null ||
                                      _currentPhotoUrl!.isEmpty))
                              ? const Icon(Icons.person,
                                  size: 60, color: Colors.blue)
                              : null,
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                size: 18, color: Colors.white),
                            onPressed: _isLoading ? null : _pickAndCompressImage,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ketuk ikon kamera untuk mengganti foto (Otomatis dikompres)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Form Input Data Pribadi
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? 'Nama lengkap wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _roleController,
                      decoration: const InputDecoration(
                        labelText: 'Jabatan / Role',
                        hintText: 'Contoh: Teknisi / Admin Pusat',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Nomor HP / WhatsApp',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Alamat Lengkap',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Tombol Simpan
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
                          _isLoading ? 'Menyimpan & Mengunggah...' : 'Simpan Perubahan',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isLoading ? null : _saveProfile,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}