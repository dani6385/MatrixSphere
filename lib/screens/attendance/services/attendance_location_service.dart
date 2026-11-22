// lib/screens/Attendance/services/attendance_location_service.dart

import 'package:geolocator/geolocator.dart';
import '../models/attendance_radius_config.dart';

class AttendanceLocationData {
  final double latitude;
  final double longitude;
  final double accuracy;
  final double? distanceToOfficeMeters;
  final double? allowedRadiusMeters;
  final DateTime capturedAt;

  const AttendanceLocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.distanceToOfficeMeters,
    this.allowedRadiusMeters,
    required this.capturedAt,
  });
AttendanceLocationData withRadiusInfo({
    required double distanceToOfficeMeters,
    required double allowedRadiusMeters,
  }) {
    return AttendanceLocationData(
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      distanceToOfficeMeters: distanceToOfficeMeters,
      allowedRadiusMeters: allowedRadiusMeters,
      capturedAt: capturedAt,
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      if (distanceToOfficeMeters != null)
        'distanceToOfficeMeters': distanceToOfficeMeters!.round(),
      if (allowedRadiusMeters != null)
        'allowedRadiusMeters': allowedRadiusMeters!.round(),
      'capturedAt': capturedAt.toIso8601String(),
    };
  }

  AttendanceRadiusCheckResult checkRadius({
    required AttendanceLocationData currentLocation,
    required AttendanceRadiusConfig radiusConfig,
  }) {
    if (!radiusConfig.isConfigured) {
      throw const AttendanceLocationException(
        'Titik lokasi atau radius perusahaan belum diatur pada profil perusahaan.',
      );
    }

    final double distance = radiusConfig.distanceFrom(
      currentLatitude: currentLocation.latitude,
      currentLongitude: currentLocation.longitude,
    );

    final bool within = distance <= radiusConfig.radiusMeters;

    return AttendanceRadiusCheckResult(
      isWithinRadius: within,
      distanceMeters: distance,
      allowedRadiusMeters: radiusConfig.radiusMeters,
    );
  }
}

class AttendanceLocationException implements Exception {
  final String message;
  const AttendanceLocationException(this.message);

  @override
  String toString() => message;
}

class AttendanceLocationService {
  Future<AttendanceLocationData> getCurrentLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const AttendanceLocationException(
        'Layanan GPS/Lokasi perangkat nonaktif. Aktifkan lokasi terlebih dahulu.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const AttendanceLocationException(
          'Izin lokasi ditolak. Absensi memerlukan akses lokasi.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const AttendanceLocationException(
        'Izin lokasi ditolak permanen. Buka Pengaturan aplikasi untuk mengaktifkan izin lokasi.',
      );
    }

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 12),
      ),
    );

    return AttendanceLocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      capturedAt: DateTime.now(),
    );
  }
}
