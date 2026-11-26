import 'company_profile_model.dart';

class AccessRoleResult {
  final bool isAdmin;
  final bool isHrManager;

  const AccessRoleResult({
    required this.isAdmin,
    required this.isHrManager,
  });

  bool get canManageOvertime => isAdmin || isHrManager;
}

class CompanyProfileViewData {
  final CompanyProfileModel company;
  final String workDaysLabel;
  final String workStart;
  final String effectiveWorkEnd;
  final String rawOvertimeWork;
  final bool isOvertimeActive;
  final bool isOvertimeExpired;
  final bool decreeEnabled;
  final String decreeNumber;
  final String decreeNote;
  final bool allowWeekdayOvertime;
  final String weekdayOvertimeEnd;
  final bool allowSaturdayOvertime;
  final String saturdayStart;
  final String saturdayEnd;
  final bool allowSundayOvertime;
  final String sundayStart;
  final String sundayEnd;
  final bool requireLocation;
  final bool requirePhoto;
  final bool allowOutsideRadius;
  final int graceMinutes;
  final String photoTypeLabel;
  final String coordinateText;
  final String radiusText;

  const CompanyProfileViewData({
    required this.company,
    required this.workDaysLabel,
    required this.workStart,
    required this.effectiveWorkEnd,
    required this.rawOvertimeWork,
    required this.isOvertimeActive,
    required this.isOvertimeExpired,
    required this.decreeEnabled,
    required this.decreeNumber,
    required this.decreeNote,
    required this.allowWeekdayOvertime,
    required this.weekdayOvertimeEnd,
    required this.allowSaturdayOvertime,
    required this.saturdayStart,
    required this.saturdayEnd,
    required this.allowSundayOvertime,
    required this.sundayStart,
    required this.sundayEnd,
    required this.requireLocation,
    required this.requirePhoto,
    required this.allowOutsideRadius,
    required this.graceMinutes,
    required this.photoTypeLabel,
    required this.coordinateText,
    required this.radiusText,
  });
}