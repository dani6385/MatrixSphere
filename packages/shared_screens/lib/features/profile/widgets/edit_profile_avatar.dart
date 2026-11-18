import 'dart:io';
import 'package:flutter/material.dart';

class EditProfileAvatar extends StatelessWidget {
  final File? selectedImageFile;
  final String? currentPhotoUrl;
  final bool isLoading;
  final VoidCallback onCameraPressed;

  const EditProfileAvatar({
    super.key,
    required this.selectedImageFile,
    required this.currentPhotoUrl,
    required this.isLoading,
    required this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: selectedImageFile != null
                  ? FileImage(selectedImageFile!) as ImageProvider
                  : (currentPhotoUrl != null && currentPhotoUrl!.isNotEmpty)
                      ? NetworkImage(currentPhotoUrl!)
                      : null,
              child: (selectedImageFile == null &&
                      (currentPhotoUrl == null || currentPhotoUrl!.isEmpty))
                  ? const Icon(Icons.person, size: 60, color: Colors.blue)
                  : null,
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                onPressed: isLoading ? null : onCameraPressed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Ketuk ikon kamera untuk mengganti foto (Otomatis dikompres)',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}