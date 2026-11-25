import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../core/edit_company_constants.dart';
import '../models/company_profile_model.dart';
import '../models/edit_company_form_state.dart';
import '../services/edit_company_service.dart';

class EditCompanyController extends ChangeNotifier {
  final CompanyProfileModel? initialCompany;
  late final EditCompanyFormState formState;

  bool isCheckingAdmin = true;
  bool isAdmin = false;
  bool isSaving = false;

  EditCompanyController({this.initialCompany}) {
    formState = EditCompanyFormState(initialCompany: initialCompany);
    _init();
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
    final bool adminAccess = await EditCompanyService.checkIsAdmin();
    final Map<dynamic, dynamic>? data =
        await EditCompanyService.loadCompanyProfileMap();

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
        fallback: EditCompanyConstants.defaultWorkStart,
      );
      formState.matrixEndController.text = _readTextOrDefault(
        data,
        ['matrixSphereWorkEnd'],
        fallback: EditCompanyConstants.defaultWorkEnd,
      );
      formState.latitudeController.text =
          _readTextOrDefault(data, ['latitude', 'lat']);
      formState.longitudeController.text =
          _readTextOrDefault(data, ['longitude', 'lng']);
      formState.radiusMetersController.text = _readTextOrDefault(
        data,
        ['radiusMeters', 'radius_meters', 'radius', 'attendanceRadius'],
        fallback: EditCompanyConstants.defaultRadiusMeters,
      );
      formState.graceMinutesController.text = _readTextOrDefault(
        data,
        ['graceMinutes', 'grace_minutes'],
        fallback: EditCompanyConstants.defaultGraceMinutes,
      );

      formState.isOvertimeRequired = _parseOvertimeRequired(data);
      formState.decreeNumberController.text =
          _readTextOrDefault(data, ['overtimeDecreeNumber']);
      formState.decreeNoteController.text = _readTextOrDefault(
        data,
        ['overtimeDecreeNote'],
        fallback: EditCompanyConstants.defaultDecreeNote,
      );
      formState.weekdayOvertimeEndController.text = _readTextOrDefault(
        data,
        ['weekdayOvertimeEnd'],
        fallback: EditCompanyConstants.defaultWeekdayOvertimeEnd,
      );
      formState.saturdayStartController.text = _readTextOrDefault(
        data,
        ['saturdayOvertimeStart'],
        fallback: EditCompanyConstants.defaultWeekendStart,
      );
      formState.saturdayEndController.text = _readTextOrDefault(
        data,
        ['saturdayOvertimeEnd'],
        fallback: EditCompanyConstants.defaultWeekendEnd,
      );
      formState.sundayStartController.text = _readTextOrDefault(
        data,
        ['sundayOvertimeStart'],
        fallback: EditCompanyConstants.defaultWeekendStart,
      );
      formState.sundayEndController.text = _readTextOrDefault(
        data,
        ['sundayOvertimeEnd'],
        fallback: EditCompanyConstants.defaultWeekendEnd,
      );
      formState.overtimeScheduleTextController.text = _readTextOrDefault(
        data,
        ['overtimeScheduleText', 'overtimeLimitText'],
        fallback: EditCompanyConstants.defaultOvertimeScheduleText,
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
        int.tryParse(formState.graceMinutesController.text.trim()) ?? 15;

    final bool isOvertime = formState.isOvertimeRequired;
    final String overtimeMode = isOvertime ? 'overtime' : 'go_home';
    final String rawScheduleInput =
        formState.overtimeScheduleTextController.text.trim();
    final String scheduleText = isOvertime
        ? (rawScheduleInput.isEmpty
            ? EditCompanyConstants.defaultOvertimeScheduleText
            : rawScheduleInput)
        : 'Pulang';

    isSaving = true;
    notifyListeners();

    try {
      await EditCompanyService.saveCompanyProfile(<String, Object?>{
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
        'isAttendanceEnabled': EditCompanyConstants.mandatoryAttendanceEnabled,
        'requireLocationAttendance':
            EditCompanyConstants.mandatoryLocationRequired,
        'allowOutsideRadius': EditCompanyConstants.disallowOutsideRadius,
        'requirePhotoAttendance': EditCompanyConstants.mandatoryPhotoRequired,
        'photoType': EditCompanyConstants.mandatoryPhotoType,
        // Lembur aktif atau pulang + teks jadwal lembur
        'overtimeMode': overtimeMode,
        'overtimeStatusText': isOvertime ? 'Lembur Aktif' : 'Pulang',
        'overtimeScheduleText': scheduleText,
        'overtimeAction': scheduleText,
        'overtimeDecreeEnabled': isOvertime,
        'overtimeDecreeNumber': formState.decreeNumberController.text.trim(),
        'overtimeDecreeNote': isOvertime
            ? formState.decreeNoteController.text.trim()
            : EditCompanyConstants.noOvertimeNote,
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
      await EditCompanyService.logError(e, stack);
      onShowMessage('Gagal menyimpan perubahan: $e');
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    formState.dispose();
    super.dispose();
  }
}