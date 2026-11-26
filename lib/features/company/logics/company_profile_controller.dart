import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../core/company_profile_constants.dart';
import '../models/company_profile_model.dart';
import '../models/company_profile_view_data.dart';
import '../models/edit_company_form_state.dart';
import '../services/company_profile_service.dart';

class CompanyProfileController extends ChangeNotifier {
  final CompanyProfileModel? initialCompany;
  late final CompanyFormState formState;

  final TextEditingController overtimeWorkController = TextEditingController();
  final FocusNode overtimeFocusNode = FocusNode();

  late final Stream<DatabaseEvent> companyStream;
  late final Future<AccessRoleResult> accessRoleFuture;

  Timer? _clockTimer;
  String _lastSyncedOvertimeText = '';

  bool isCheckingAdmin = true;
  bool isAdmin = false;
  bool isSaving = false;
  bool isSavingOvertime = false;

  CompanyProfileController({this.initialCompany}) {
    formState = CompanyFormState(initialCompany: initialCompany);
    companyStream = CompanyProfileService.watchCompanyProfile();
    accessRoleFuture = CompanyProfileService.resolveAccessRole(
      FirebaseAuth.instance.currentUser,
    );

    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      notifyListeners();
    });

    _init();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    overtimeWorkController.dispose();
    overtimeFocusNode.dispose();
    formState.dispose();
    super.dispose();
  }

  String _readTextOrDefault(
    Map<dynamic, dynamic> data,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final String key in keys) {
      final dynamic val = data[key];
      if (val != null && val.toString().trim().isNotEmpty) {
        return val.toString().trim();
      }
    }
    return fallback;
  }

  bool _parseOvertimeRequired(Map<dynamic, dynamic> data) {
    final String mode =
        data['overtimeMode']?.toString().trim().toLowerCase() ?? '';
    if (mode == 'overtime' || mode == 'active') return true;
    if (mode == 'go_home' || mode == 'pulang' || mode == 'off') return false;

    final dynamic rawDecree = data['overtimeDecreeEnabled'];
    if (rawDecree is bool) return rawDecree;
    if (rawDecree is num) return rawDecree != 0;
    if (rawDecree is String) {
      final String lower = rawDecree.trim().toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'lembur') return true;
      if (lower == 'false' || lower == '0' || lower == 'pulang') return false;
    }
    return false;
  }

  Future<void> _init() async {
    final bool adminAccess = await CompanyService.checkIsAdmin();
    final Map<dynamic, dynamic>? data =
        await CompanyService.loadCompanyProfileMap();

    if (data != null) {
      if (initialCompany == null) {
        formState.nameController.text =
            data['name']?.toString() ?? formState.nameController.text;
        formState.emailController.text =
            data['email']?.toString() ?? formState.emailController.text;
        formState.phoneController.text =
            data['phone']?.toString() ?? formState.phoneController.text;
        formState.addressController.text =
            data['address']?.toString() ?? formState.addressController.text;
        formState.descriptionController.text =
            data['description']?.toString() ?? formState.descriptionController.text;
      }

      formState.matrixStartController.text = _readTextOrDefault(
        data,
        ['matrixSphereWorkStart'],
        fallback: CompanyProfileConstants.defaultWorkStart,
      );
      formState.matrixEndController.text = _readTextOrDefault(
        data,
        ['matrixSphereWorkEnd'],
        fallback: CompanyProfileConstants.defaultWorkEnd,
      );
      formState.latitudeController.text =
          _readTextOrDefault(data, ['latitude', 'lat']);
      formState.longitudeController.text =
          _readTextOrDefault(data, ['longitude', 'lng']);
      formState.radiusMetersController.text = _readTextOrDefault(
        data,
        ['radiusMeters', 'radius_meters', 'radius', 'attendanceRadius'],
        fallback: CompanyProfileConstants.defaultRadiusMeters,
      );
      formState.graceMinutesController.text = _readTextOrDefault(
        data,
        ['graceMinutes', 'grace_minutes'],
        fallback: CompanyProfileConstants.defaultGraceMinutesStr,
      );

      formState.isOvertimeRequired = _parseOvertimeRequired(data);
      formState.decreeNumberController.text =
          _readTextOrDefault(data, ['overtimeDecreeNumber']);
      formState.decreeNoteController.text = _readTextOrDefault(
        data,
        ['overtimeDecreeNote'],
        fallback: CompanyProfileConstants.defaultDecreeNote,
      );
      formState.weekdayOvertimeEndController.text = _readTextOrDefault(
        data,
        ['weekdayOvertimeEnd'],
        fallback: CompanyProfileConstants.defaultWeekdayOvertimeEnd,
      );
      formState.saturdayStartController.text = _readTextOrDefault(
        data,
        ['saturdayOvertimeStart'],
        fallback: CompanyProfileConstants.defaultWeekendStart,
      );
      formState.saturdayEndController.text = _readTextOrDefault(
        data,
        ['saturdayOvertimeEnd'],
        fallback: CompanyProfileConstants.defaultWeekendEnd,
      );
      formState.sundayStartController.text = _readTextOrDefault(
        data,
        ['sundayOvertimeStart'],
        fallback: CompanyProfileConstants.defaultWeekendStart,
      );
      formState.sundayEndController.text = _readTextOrDefault(
        data,
        ['sundayOvertimeEnd'],
        fallback: CompanyProfileConstants.defaultWeekendEnd,
      );
      formState.overtimeScheduleTextController.text = _readTextOrDefault(
        data,
        ['overtimeScheduleText', 'overtimeLimitText'],
        fallback: CompanyProfileConstants.defaultOvertimeScheduleText,
      );
    }

    isAdmin = adminAccess;
    isCheckingAdmin = false;
    notifyListeners();
  }

  void setOvertimeRequired(bool value) {
    if (!isAdmin) return;
    formState.isOvertimeRequired = value;
    notifyListeners();
  }

  TimeOfDay? extractDeadlineTime(String rawText) {
    final String text = rawText.trim().toLowerCase();
    if (text.isEmpty) return null;

    final RegExp hhmmRegex = RegExp(r'\b([01]?\d|2[0-3])[:.]([0-5]\d)\b');
    final RegExpMatch? hhmmMatch = hhmmRegex.firstMatch(text);
    if (hhmmMatch != null) {
      int hour = int.parse(hhmmMatch.group(1)!);
      final int minute = int.parse(hhmmMatch.group(2)!);
      if (hour >= 1 &&
          hour <= 11 &&
          (text.contains('malam') || text.contains('sore'))) {
        hour += 12;
      }
      return TimeOfDay(hour: hour, minute: minute);
    }

    final RegExp hourWordRegex = RegExp(
      r'(?:jam|pukul|sampai|s\.d\.?)\s*([01]?\d|2[0-3])\b',
    );
    final RegExpMatch? hourMatch = hourWordRegex.firstMatch(text);
    if (hourMatch != null) {
      int hour = int.parse(hourMatch.group(1)!);
      if (hour >= 1 &&
          hour <= 11 &&
          (text.contains('malam') || text.contains('sore'))) {
        hour += 12;
      }
      return TimeOfDay(hour: hour, minute: 0);
    }

    return null;
  }

  bool isOvertimeExpired(String rawText, int? savedAtMillis) {
    final String trimmed = rawText.trim();
    if (trimmed.isEmpty) return true;

    final DateTime now = DateTime.now();

    if (savedAtMillis != null && savedAtMillis > 0) {
      final DateTime savedDate =
          DateTime.fromMillisecondsSinceEpoch(savedAtMillis);
      final bool isDifferentDay = savedDate.year != now.year ||
          savedDate.month != now.month ||
          savedDate.day != now.day;
      if (isDifferentDay) return true;
    }

    final TimeOfDay? deadline = extractDeadlineTime(trimmed);
    if (deadline == null) return false;

    final DateTime deadlineToday = DateTime(
      now.year,
      now.month,
      now.day,
      deadline.hour,
      deadline.minute,
    );
    return now.isAfter(deadlineToday);
  }

  String formatTimeOfDay(TimeOfDay time) {
    final String h = time.hour.toString().padLeft(2, '0');
    final String m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> saveOvertimeWork({
    required bool canEdit,
    required void Function(String message) onShowMessage,
  }) async {
    if (!canEdit || isSavingOvertime) return;

    final String text = overtimeWorkController.text.trim();
    final TimeOfDay? parsedDeadline = extractDeadlineTime(text);
    final bool hasText = text.isNotEmpty;
    final bool alreadyPassed = hasText && isOvertimeExpired(text, null);
    final bool isActiveNow = hasText && !alreadyPassed;

    final String effectiveCheckout = isActiveNow && parsedDeadline != null
        ? formatTimeOfDay(parsedDeadline)
        : CompanyProfileConstants.defaultCheckoutTime;

    isSavingOvertime = true;
    notifyListeners();

    try {
      await CompanyProfileService.updateOvertimeWork(<String, Object?>{
        'overtimeWork': isActiveNow ? text : '',
        'overtimeWorkActive': isActiveNow,
        'overtimeDeadline': isActiveNow && parsedDeadline != null
            ? formatTimeOfDay(parsedDeadline)
            : null,
        'effectiveCheckoutTime': effectiveCheckout,
        'overtimeUpdatedAt': ServerValue.timestamp,
        'overtimeUpdatedBy': FirebaseAuth.instance.currentUser?.uid,
      });

      overtimeFocusNode.unfocus();
      onShowMessage(
        !hasText
            ? 'Field lembur dikosongkan. Jam pulang ditetapkan pada ${CompanyProfileConstants.defaultCheckoutTime}.'
            : alreadyPassed
                ? 'Jam lembur sudah terlewati. Status nonaktif & jam pulang ditetapkan ${CompanyProfileConstants.defaultCheckoutTime}.'
                : 'Jadwal lembur disimpan. Jam pulang efektif: $effectiveCheckout.',
      );
    } catch (error, stack) {
      await CompanyProfileService.logError(error, stack);
      onShowMessage('Gagal menyimpan jadwal lembur: $error');
    } finally {
      isSavingOvertime = false;
      notifyListeners();
    }
  }

  void clearOvertimeWork({
    required bool canEdit,
    required void Function(String message) onShowMessage,
  }) {
    overtimeWorkController.clear();
    saveOvertimeWork(canEdit: canEdit, onShowMessage: onShowMessage);
  }

  Future<bool> saveChanges({
    required void Function(String message) onShowMessage,
  }) async {
    if (!isAdmin || isSaving) return false;
    if (!(formState.formKey.currentState?.validate() ?? false)) return false;

    final double? lat =
        double.tryParse(formState.latitudeController.text.trim());
    final double? lng =
        double.tryParse(formState.longitudeController.text.trim());
    final double? radius =
        double.tryParse(formState.radiusMetersController.text.trim());
    final int graceMinutes =
        int.tryParse(formState.graceMinutesController.text.trim()) ??
            CompanyProfileConstants.defaultGraceMinutes;

    final bool isOvertime = formState.isOvertimeRequired;
    final String overtimeMode = isOvertime ? 'overtime' : 'go_home';
    final String rawScheduleInput =
        formState.overtimeScheduleTextController.text.trim();
    final String scheduleText = isOvertime
        ? (rawScheduleInput.isEmpty
            ? CompanyProfileConstants.defaultOvertimeScheduleText
            : rawScheduleInput)
        : 'Pulang';

    isSaving = true;
    notifyListeners();

    try {
      await CompanyService.saveCompanyProfile(<String, Object?>{
        'name': formState.nameController.text.trim(),
        'email': formState.emailController.text.trim(),
        'phone': formState.phoneController.text.trim(),
        'address': formState.addressController.text.trim(),
        'description': formState.descriptionController.text.trim(),
        'workDays': <int>[1, 2, 3, 4, 5],
        'matrixSphereWorkStart': formState.matrixStartController.text.trim(),
        'matrixSphereWorkEnd': formState.matrixEndController.text.trim(),
        'latitude': lat,
        'longitude': lng,
        'radiusMeters': radius,
        'graceMinutes': graceMinutes,
        'isAttendanceEnabled': CompanyProfileConstants.mandatoryAttendanceEnabled,
        'requireLocationAttendance':
            CompanyProfileConstants.mandatoryLocationRequired,
        'allowOutsideRadius': CompanyProfileConstants.disallowOutsideRadius,
        'requirePhotoAttendance': CompanyProfileConstants.mandatoryPhotoRequired,
        'photoType': CompanyProfileConstants.mandatoryPhotoType,
        'overtimeMode': overtimeMode,
        'overtimeStatusText': isOvertime ? 'Lembur Aktif' : 'Pulang',
        'overtimeScheduleText': scheduleText,
        'overtimeAction': scheduleText,
        'overtimeDecreeEnabled': isOvertime,
        'overtimeDecreeNumber': formState.decreeNumberController.text.trim(),
        'overtimeDecreeNote': isOvertime
            ? formState.decreeNoteController.text.trim()
            : CompanyProfileConstants.noOvertimeNote,
        'allowWeekdayOvertime': isOvertime,
        'weekdayOvertimeEnd': formState.weekdayOvertimeEndController.text.trim(),
        'allowSaturdayOvertime': isOvertime,
        'saturdayOvertimeStart': formState.saturdayStartController.text.trim(),
        'saturdayOvertimeEnd': formState.saturdayEndController.text.trim(),
        'allowSundayOvertime': isOvertime,
        'sundayOvertimeStart': formState.sundayStartController.text.trim(),
        'sundayOvertimeEnd': formState.sundayEndController.text.trim(),
        'overtimeUpdatedAt': ServerValue.timestamp,
      });

      final String statusSummary =
          isOvertime ? 'Lembur Aktif ($scheduleText)' : 'Pulang';
      onShowMessage('Tersimpan • Status saat ini: $statusSummary.');
      return true;
    } catch (e, stack) {
      await CompanyService.logError(e, stack);
      onShowMessage('Gagal menyimpan perubahan: $e');
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  CompanyProfileViewData buildViewData(Map<dynamic, dynamic>? rawData) {
    final CompanyProfileModel company = CompanyProfileModel.fromMap(rawData);

    final String matrixStart =
        rawData?['matrixSphereWorkStart']?.toString() ??
            CompanyProfileConstants.defaultWorkStart;
    final String rawOvertimeWork =
        rawData?['overtimeWork']?.toString().trim() ?? '';
    final int? overtimeUpdatedAt =
        (rawData?['overtimeUpdatedAt'] as num?)?.toInt();

    final bool expired = isOvertimeExpired(rawOvertimeWork, overtimeUpdatedAt);
    final bool active = rawOvertimeWork.isNotEmpty && !expired;
    final TimeOfDay? overtimeDeadline =
        active ? extractDeadlineTime(rawOvertimeWork) : null;

    final String effectiveWorkEnd = active
        ? (overtimeDeadline != null
            ? formatTimeOfDay(overtimeDeadline)
            : (rawData?['matrixSphereWorkEnd']?.toString() ??
                CompanyProfileConstants.defaultCheckoutTime))
        : CompanyProfileConstants.defaultCheckoutTime;

    final String displayFieldValue = active ? rawOvertimeWork : '';
    if (!overtimeFocusNode.hasFocus &&
        _lastSyncedOvertimeText != displayFieldValue) {
      _lastSyncedOvertimeText = displayFieldValue;
      overtimeWorkController.text = displayFieldValue;
    }

    final List<int> workDays = _parseWorkDays(rawData?['workDays']);
    final String workDaysLabel = _formatWorkDaysLabel(workDays);

    final bool overtimeDecreeEnabled = _parseBool(
      rawData?['overtimeDecreeEnabled'],
      fallback: false,
    );
    final String overtimeDecreeNumber =
        rawData?['overtimeDecreeNumber']?.toString().trim() ?? '';
    final String baseDecreeNote =
        rawData?['overtimeDecreeNote']?.toString().trim() ??
            'Pekerja diperbolehkan mengambil lembur sesuai kebutuhan operasional berdasarkan dekrit resmi Matrix Sphere.';

    final double? officeLat =
        _parseDouble(rawData?['latitude'] ?? rawData?['lat']);
    final double? officeLng =
        _parseDouble(rawData?['longitude'] ?? rawData?['lng']);
    final double? radiusMeters = _parseDouble(
      rawData?['radiusMeters'] ??
          rawData?['radius_meters'] ??
          rawData?['radius'] ??
          rawData?['attendanceRadius'],
    );

    final bool hasLocationConfig = officeLat != null && officeLng != null;
    final String coordinateText = hasLocationConfig
        ? '${officeLat.toStringAsFixed(6)}, ${officeLng.toStringAsFixed(6)}'
        : 'Belum diatur';
    final String radiusText = (radiusMeters != null && radiusMeters > 0)
        ? '${radiusMeters.round()} meter'
        : 'Belum diatur (default 100 meter)';

    return CompanyProfileViewData(
      company: company,
      workDaysLabel: workDaysLabel,
      workStart: matrixStart,
      effectiveWorkEnd: effectiveWorkEnd,
      rawOvertimeWork: rawOvertimeWork,
      isOvertimeActive: active,
      isOvertimeExpired: rawOvertimeWork.isNotEmpty && expired,
      decreeEnabled: overtimeDecreeEnabled || active,
      decreeNumber: overtimeDecreeNumber,
      decreeNote: active
          ? 'Lembur aktif: $rawOvertimeWork (Jam pulang efektif: $effectiveWorkEnd)'
          : baseDecreeNote,
      allowWeekdayOvertime: _parseBool(
        rawData?['allowWeekdayOvertime'],
        fallback: true,
      ),
      weekdayOvertimeEnd: rawData?['weekdayOvertimeEnd']?.toString() ??
          CompanyProfileConstants.defaultWeekdayOvertimeEnd,
      allowSaturdayOvertime: _parseBool(
        rawData?['allowSaturdayOvertime'],
        fallback: true,
      ),
      saturdayStart: rawData?['saturdayOvertimeStart']?.toString() ??
          CompanyProfileConstants.defaultWeekendStart,
      saturdayEnd: rawData?['saturdayOvertimeEnd']?.toString() ??
          CompanyProfileConstants.defaultWeekendEnd,
      allowSundayOvertime: _parseBool(
        rawData?['allowSundayOvertime'],
        fallback: true,
      ),
      sundayStart: rawData?['sundayOvertimeStart']?.toString() ??
          CompanyProfileConstants.defaultWeekendStart,
      sundayEnd: rawData?['sundayOvertimeEnd']?.toString() ??
          CompanyProfileConstants.defaultWeekendEnd,
      requireLocation: _parseBool(
        rawData?['requireLocationAttendance'],
        fallback: true,
      ),
      requirePhoto: _parseBool(
        rawData?['requirePhotoAttendance'],
        fallback: true,
      ),
      allowOutsideRadius: _parseBool(
        rawData?['allowOutsideRadius'],
        fallback: false,
      ),
      graceMinutes: _parseInt(
        rawData?['graceMinutes'],
        fallback: CompanyProfileConstants.defaultGraceMinutes,
      ),
      photoTypeLabel: _formatPhotoType(rawData?['photoType']?.toString()),
      coordinateText: coordinateText,
      radiusText: radiusText,
    );
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim());
  }

  int _parseInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim()) ?? fallback;
  }

  bool _parseBool(dynamic value, {bool fallback = false}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final String lower = value.toString().trim().toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
    return fallback;
  }

  List<int> _parseWorkDays(dynamic raw) {
    if (raw is List) {
      final List<int> parsed = raw
          .map((e) => int.tryParse(e.toString().trim()) ?? 0)
          .where((d) => d >= 1 && d <= 7)
          .toSet()
          .toList()
        ..sort();
      if (parsed.isNotEmpty) return parsed;
    }
    return <int>[1, 2, 3, 4, 5];
  }

  String _formatWorkDaysLabel(List<int> days) {
    if (days.length == 5 &&
        days[0] == 1 &&
        days[1] == 2 &&
        days[2] == 3 &&
        days[3] == 4 &&
        days[4] == 5) {
      return 'Senin - Jumat';
    }
    return days
        .map((d) => CompanyProfileConstants.dayLabels[d] ?? '')
        .where((s) => s.isNotEmpty)
        .join(', ');
  }

  String _formatPhotoType(String? rawType) {
    switch (rawType?.trim()) {
      case 'front_selfie':
        return 'Kamera Depan (Selfie)';
      case 'rear_site':
        return 'Kamera Belakang (Bukti Lokasi/Kerja)';
      case 'both':
        return 'Kamera Depan & Belakang';
      default:
        return 'Kamera Depan (Selfie)';
    }
  }
}

typedef CompanyController = CompanyProfileController;