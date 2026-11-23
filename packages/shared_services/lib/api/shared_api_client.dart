// shared_services/lib/api/shared_api_client.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Klien HTTP bersama untuk permintaan JSON umum dan reverse geocoding.
class SharedApiClient {
  final http.Client _client;

  /// Batas waktu tunggu default untuk setiap permintaan HTTP.
  final Duration timeout;

  /// Identitas User-Agent untuk permintaan Nominatim.
  final String nominatimUserAgent;

  /// Membuat instance [SharedApiClient].
  /// Jika [client] tidak diberikan, akan membuat [http.Client] baru secara otomatis.
  SharedApiClient({
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
    this.nominatimUserAgent = 'MatrixSphereApp/1.0',
  }) : _client = client ?? http.Client();

  /// Membantu mengurai respons HTTP menjadi [Map<String, dynamic>].
  Map<String, dynamic> _parseJsonMap(http.Response response, String method, Uri uri) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        '$method ${uri.path} gagal dengan status ${response.statusCode}',
        uri: uri,
      );
    }

    final String trimmedBody = response.body.trim();
    if (trimmedBody.isEmpty) {
      return <String, dynamic>{};
    }

    final dynamic decoded = jsonDecode(trimmedBody);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    // Jika respons JSON berupa List atau tipe lain, bungkus ke dalam key 'data'.
    return <String, dynamic>{'data': decoded};
  }

  /// Helper HTTP GET JSON umum.
  Future<Map<String, dynamic>> getJson(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    final http.Response response = await _client
        .get(uri, headers: headers)
        .timeout(timeout);

    return _parseJsonMap(response, 'GET', uri);
  }

  /// Helper HTTP POST JSON umum.
  Future<Map<String, dynamic>> postJson(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final Map<String, String> mergedHeaders = <String, String>{
      'Content-Type': 'application/json',
      ...?headers,
    };

    final http.Response response = await _client
        .post(
          uri,
          headers: mergedHeaders,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(timeout);

    return _parseJsonMap(response, 'POST', uri);
  }

  /// Mengubah koordinat GPS ([lat], [lng]) menjadi alamat terbaca
  /// menggunakan OpenStreetMap Nominatim.
  /// Cocok untuk mencatat `locationAddress` saat absensi.
  Future<String?> reverseGeocode({
    required double lat,
    required double lng,
    String language = 'id',
  }) async {
    try {
      final Uri uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/reverse',
        <String, String>{
          'format': 'jsonv2',
          'lat': lat.toString(),
          'lon': lng.toString(),
          'accept-language': language,
        },
      );

      final Map<String, dynamic> result = await getJson(
        uri,
        headers: <String, String>{
          // Nominatim mewajibkan header User-Agent yang jelas.
          'User-Agent': nominatimUserAgent,
        },
      );

      final String? displayName = result['display_name']?.toString().trim();
      return (displayName != null && displayName.isNotEmpty)
          ? displayName
          : null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SharedApiClient] reverseGeocode error: $e');
      }
      return null;
    }
  }

  /// Menutup koneksi [http.Client] jika sudah tidak digunakan lagi.
  void dispose() {
    _client.close();
  }
}

/// Global instance siap pakai.
final SharedApiClient sharedApiClient = SharedApiClient();