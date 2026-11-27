import 'package:flutter/material.dart';

import '../../models/attendance_rule_model.dart';
import '../../models/company_profile_model.dart';

class CompanyProfileFormController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController logoUrlController = TextEditingController();
  final TextEditingController bannerUrlController = TextEditingController();

  final TextEditingController workStartController = TextEditingController();
  final TextEditingController workEndController = TextEditingController();
  final TextEditingController graceMinutesController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  bool isAttendanceEnabled = true;
  bool requireLocationAttendance = true;
  bool requirePhotoAttendance = true;
  bool allowOutsideRadius = false;
  String photoType = 'front_selfie';
  bool isPopulated = false;

  void populateFromBundle(
    CompanyProfileModel company,
    AttendanceRuleModel rule,
  ) {
    if (isPopulated) return;
    isPopulated = true;

    nameController.text = company.name;
    emailController.text = company.email;
    phoneController.text = company.phone ?? '';
    addressController.text = company.address ?? '';
    descriptionController.text = company.description ?? '';
    logoUrlController.text = company.logoUrl ?? '';

    workStartController.text = rule.workStart;
    workEndController.text = rule.workEnd;
    graceMinutesController.text = rule.graceMinutes.toString();
    latitudeController.text = rule.latitude?.toString() ?? '';
    longitudeController.text = rule.longitude?.toString() ?? '';
    radiusController.text = rule.radiusMeters?.round().toString() ?? '';

    isAttendanceEnabled = rule.isAttendanceEnabled;
    requireLocationAttendance = rule.requireLocation;
    requirePhotoAttendance = rule.requirePhoto;
    allowOutsideRadius = rule.allowOutsideRadius;

    switch (rule.photoTypeLabel) {
      case 'Kamera Belakang (Bukti Lokasi/Kerja)':
        photoType = 'rear_site';
        break;
      case 'Kamera Depan & Belakang':
        photoType = 'both';
        break;
      default:
        photoType = 'front_selfie';
    }
  }

  Map<String, dynamic> toPayload() {
    double? tryDouble(TextEditingController c) {
      final String raw = c.text.trim().replaceAll(',', '.');
      if (raw.isEmpty) return null;
      return double.tryParse(raw);
    }

    int? tryInt(TextEditingController c) {
      final String raw = c.text.trim();
      if (raw.isEmpty) return null;
      return int.tryParse(raw);
    }

    return {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      'address': addressController.text.trim().isEmpty
          ? null
          : addressController.text.trim(),
      'description': descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      'logoUrl': logoUrlController.text.trim().isEmpty
          ? null
          : logoUrlController.text.trim(),
      'matrixSphereWorkStart': workStartController.text.trim(),
      'matrixSphereWorkEnd': workEndController.text.trim(),
      'isAttendanceEnabled': true,
      'requireLocationAttendance': true,
      'requirePhotoAttendance': true,
      'allowOutsideRadius': allowOutsideRadius,
      'graceMinutes': tryInt(graceMinutesController) ?? 15,
      'photoType': photoType,
      'latitude': tryDouble(latitudeController),
      'longitude': tryDouble(longitudeController),
      'radiusMeters': tryDouble(radiusController),
    };
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    logoUrlController.dispose();
    workStartController.dispose();
    workEndController.dispose();
    graceMinutesController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    radiusController.dispose();
  }
}
