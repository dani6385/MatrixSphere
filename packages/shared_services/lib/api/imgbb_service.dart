// shared_services/lib/api/imgbb_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_keys.dart';

/// Model hasil unggahan dari ImgBB
class ImgbbUploadResult {
  final String id;
  final String title;
  final String url;
  final String displayUrl;
  final String thumbUrl;
  final String deleteUrl;
  final int size;

  const ImgbbUploadResult({
    required this.id,
    required this.title,
    required this.url,
    required this.displayUrl,
    required this.thumbUrl,
    required this.deleteUrl,
    required this.size,
  });

  factory ImgbbUploadResult.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        (json['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final Map<String, dynamic> thumb =
        (data['thumb'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return ImgbbUploadResult(
      id: data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      url: data['url']?.toString() ?? '',
      displayUrl: data['display_url']?.toString() ?? data['url']?.toString() ?? '',
      thumbUrl: thumb['url']?.toString() ?? data['url']?.toString() ?? '',
      deleteUrl: data['delete_url']?.toString() ?? '',
      size: int.tryParse(data['size']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'title': title,
        'url': url,
        'displayUrl': displayUrl,
        'thumbUrl': thumbUrl,
        'deleteUrl': deleteUrl,
        'size': size,
      };
}

/// Service terpusat untuk upload gambar ke ImgBB
class ImgbbService {
  static const String _uploadEndpoint = 'https://api.imgbb.com/1/upload';

  final String apiKey;
  final http.Client _client;

  ImgbbService({
    String? apiKey,
    http.Client? client,
  })  : apiKey = apiKey ?? ApiKeys.imgbbApiKey,
        _client = client ?? http.Client();

  /// Upload gambar dari [File] (misalnya hasil jepretan kamera absensi)
  /// [expirationSeconds]: opsional, otomatis hapus gambar setelah sekian detik (60 - 15552000)
  Future<ImgbbUploadResult> uploadFile(
    File imageFile, {
    String? fileName,
    int? expirationSeconds,
  }) async {
    final Uint8List bytes = await imageFile.readAsBytes();
    final String resolvedName =
        fileName ?? imageFile.uri.pathSegments.last;

    return uploadBytes(
      bytes,
      fileName: resolvedName,
      expirationSeconds: expirationSeconds,
    );
  }

  /// Upload gambar dari [Uint8List] (mendukung Mobile & Flutter Web)
  Future<ImgbbUploadResult> uploadBytes(
    Uint8List bytes, {
    String? fileName,
    int? expirationSeconds,
  }) async {
    if (apiKey.isEmpty || apiKey == 'ISI_API_KEY_IMGBB_ANDA_DI_SINI') {
      throw StateError('API Key ImgBB belum diatur di ApiKeys.imgbbApiKey.');
    }

    final Map<String, String> queryParams = <String, String>{
      'key': apiKey,
      if (expirationSeconds != null && expirationSeconds >= 60)
        'expiration': expirationSeconds.toString(),
    };

    final Uri uri = Uri.parse(_uploadEndpoint).replace(
      queryParameters: queryParams,
    );

    final http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: fileName ?? 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );

    if (fileName != null && fileName.trim().isNotEmpty) {
      request.fields['name'] = fileName.trim();
    }

    final http.StreamedResponse streamedResponse = await _client.send(request);
    final String responseBody = await streamedResponse.stream.bytesToString();

    final Map<String, dynamic> decoded =
        jsonDecode(responseBody) as Map<String, dynamic>;

    if (streamedResponse.statusCode != 200 || decoded['success'] != true) {
      final dynamic errorObj = decoded['error'];
      final String message = errorObj is Map
          ? (errorObj['message']?.toString() ?? 'Gagal upload ke ImgBB')
          : 'Gagal upload ke ImgBB (HTTP ${streamedResponse.statusCode})';
      throw HttpException(message);
    }

    return ImgbbUploadResult.fromJson(decoded);
  }

  /// Upload gambar dalam format Base64
  Future<ImgbbUploadResult> uploadBase64(
    String base64Image, {
    String? fileName,
    int? expirationSeconds,
  }) async {
    final String cleanBase64 = base64Image.contains(',')
        ? base64Image.split(',').last
        : base64Image;
    final Uint8List bytes = base64Decode(cleanBase64);
    return uploadBytes(
      bytes,
      fileName: fileName,
      expirationSeconds: expirationSeconds,
    );
  }
}

/// Global instance siap pakai di seluruh aplikasi (seperti `rtdbService`)
final ImgbbService imgbbService = ImgbbService();