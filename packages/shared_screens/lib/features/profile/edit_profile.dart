// lib/screens/profile/edit_profile.dart

//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_navigations/shared_navigations.dart';
//import 'services/profile_image_service.dart';
//import 'widgets/edit_profile_avatar.dart';
import 'widgets/edit_profile_form.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  //File? _selectedImageFile;
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

  /// Memilih gambar menggunakan service terpisah
  /*Future<void> _handlePickImage() async {
    final imageFile = await ProfileImageService.pickAndCompressImage();
    if (imageFile != null) {
      setState(() {
        _selectedImageFile = imageFile;
      });
    }
  }*/

  /// Menyimpan seluruh perubahan profil ke ImgBB, Firebase Auth, dan RTDB
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      String? finalPhotoUrl = _currentPhotoUrl;

      // 1. Jika pengguna memilih foto baru, unggah ke ImgBB
      /*if (_selectedImageFile != null) {
        final uploadedUrl = await ProfileImageService.uploadImageToImgBB(_selectedImageFile!);
        if (uploadedUrl != null) {
          finalPhotoUrl = uploadedUrl;
        } else {
          throw Exception('Gagal mengunggah foto ke ImgBB. Periksa API Key atau koneksi internet.');
        }
      }*/

      final String newName = _nameController.text.trim();

      // 2. Perbarui profil dasar di Firebase Auth
      await user.updateDisplayName(newName);
      if (finalPhotoUrl != null && finalPhotoUrl.isNotEmpty) {
        await user.updatePhotoURL(finalPhotoUrl);
      }

      // 3. Simpan data lengkap ke Firebase Realtime Database
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

      // Kembali ke halaman User Profile menggunakan helper aman
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
              child: Column(
                children: [
                  /*EditProfileAvatar(
                    selectedImageFile: _selectedImageFile,
                    currentPhotoUrl: _currentPhotoUrl,
                    isLoading: _isLoading,
                    onCameraPressed: _handlePickImage,
                  ),*/
                  const SizedBox(height: 24),
                  EditProfileForm(
                    formKey: _formKey,
                    nameController: _nameController,
                    roleController: _roleController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                    isLoading: _isLoading,
                    onSavePressed: _saveProfile,
                  ),
                ],
              ),
            ),
    );
  }
}