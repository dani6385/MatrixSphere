import '../config/company_config.dart';
import '../core/company_constants.dart';
import '../utils/company_parser_utils.dart';

class AttendanceRuleModel {
  final String workStart;
  final String workEnd;
  final bool isAttendanceEnabled;
  final bool requireLocation;
  final bool requirePhoto;
  final bool allowOutsideRadius;
  final int graceMinutes;
  final String photoTypeLabel;
  final double? latitude;
  final double? longitude;
  final double? radiusMeters;

  const AttendanceRuleModel({
    required this.workStart,
    required this.workEnd,
    required this.isAttendanceEnabled,
    required this.requireLocation,
    required this.requirePhoto,
    required this.allowOutsideRadius,
    required this.graceMinutes,
    required this.photoTypeLabel,
    this.latitude,
    this.longitude,
    this.radiusMeters,
  });

  factory AttendanceRuleModel.fromMap(Map<dynamic, dynamic>? rawData) {
    return AttendanceRuleModel(
      workStart:
          rawData?['matrixSphereWorkStart']?.toString() ??
          CompanyConstants.defaultWorkStart,
      workEnd:
          rawData?['matrixSphereWorkEnd']?.toString() ??
          CompanyConstants.defaultWorkEnd,
      isAttendanceEnabled: CompanyParserUtils.parseBool(
        rawData?['isAttendanceEnabled'],
        fallback: true,
      ),
      requireLocation: CompanyParserUtils.parseBool(
        rawData?['requireLocationAttendance'],
        fallback: true,
      ),
      requirePhoto: CompanyParserUtils.parseBool(
        rawData?['requirePhotoAttendance'],
        fallback: true,
      ),
      allowOutsideRadius: CompanyParserUtils.parseBool(
        rawData?['allowOutsideRadius'],
        fallback: false,
      ),
      graceMinutes: CompanyParserUtils.parseInt(
        rawData?['graceMinutes'],
        fallback: CompanyConstants.defaultGraceMinutes,
      ),
      photoTypeLabel: CompanyParserUtils.formatPhotoType(
        rawData?['photoType']?.toString(),
      ),
      latitude: CompanyParserUtils.parseDouble(
        rawData?['latitude'] ?? rawData?['lat'],
      ),
      longitude: CompanyParserUtils.parseDouble(
        rawData?['longitude'] ?? rawData?['lng'],
      ),
      radiusMeters: CompanyParserUtils.parseDouble(
        rawData?['radiusMeters'] ??
            rawData?['radius_meters'] ??
            rawData?['radius'] ??
            rawData?['attendanceRadius'],
      ),
    );
  }

  bool get hasLocationConfig => latitude != null && longitude != null;

  String get coordinateText => hasLocationConfig
      ? '${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}'
      : CompanyConfig.unconfiguredText;

  String get radiusText => (radiusMeters != null && radiusMeters! > 0)
      ? '${radiusMeters!.round()} meter'
      : '${CompanyConfig.unconfiguredText} (default ${CompanyConstants.defaultRadiusMeters.round()} meter)';
}