import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileImageService {
  // Ganti dengan API Key ImgBB Anda
  static const String _imgbbApiKey = 'f601727fed32cf7a175833d01d8a10ff';

  /// Memilih gambar dari galeri dengan kompresi otomatis (max 512x512 px, kualitas 70%)
  static Future<File?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// Mengunggah file gambar ke API ImgBB dan mengembalikan URL publiknya
  static Future<String?> uploadImageToImgBB(File imageFile) async {
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
}