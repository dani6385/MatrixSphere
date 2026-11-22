// lib/screens/attendance/models/attendance_radius_config.dart

import 'package:geolocator/geolocator.dart';

class AttendanceRadiusConfig {
  final double? officeLatitude;
  final double? officeLongitude;
  final double radiusMeters;

  const AttendanceRadiusConfig({
    required this.officeLatitude,
    required this.officeLongitude,
    required this.radiusMeters,
  });

  bool get isConfigured =>
      officeLatitude != null &&
      officeLongitude != null &&
      radiusMeters > 0;

  factory AttendanceRadiusConfig.fromCompanyMap(Map<dynamic, dynamic> data) {
    double? parseDouble(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString().trim());
    }

    final double? lat = parseDouble(data['latitude'] ?? data['lat']);
    final double? lng = parseDouble(data['longitude'] ?? data['lng']);

    final double? rawRadius = parseDouble(
      data['radiusMeters'] ??
          data['radius_meters'] ??
          data['radius'] ??
          data['attendanceRadius'],
    );

    final double radius =
        (rawRadius != null && rawRadius > 0) ? rawRadius : 100.0;

    return AttendanceRadiusConfig(
      officeLatitude: lat,
      officeLongitude: lng,
      radiusMeters: radius,
    );
  }

  double distanceFrom({
    required double currentLatitude,
    required double currentLongitude,
  }) {
    return Geolocator.distanceBetween(
      officeLatitude!,
      officeLongitude!,
      currentLatitude,
      currentLongitude,
    );
  }
}

class AttendanceRadiusCheckResult {
  final bool isWithinRadius;
  final double distanceMeters;
  final double allowedRadiusMeters;

  const AttendanceRadiusCheckResult({
    required this.isWithinRadius,
    required this.distanceMeters,
    required this.allowedRadiusMeters,
  });

  String get distanceText {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(2)} km';
    }
    return '${distanceMeters.round()} meter';
  }

  String get allowedRadiusText {
    if (allowedRadiusMeters >= 1000) {
      return '${(allowedRadiusMeters / 1000).toStringAsFixed(2)} km';
    }
    return '${allowedRadiusMeters.round()} meter';
  }
}