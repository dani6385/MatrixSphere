import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:shared_services/shared_services.dart';

import '../services/company_service.dart';

class CompanyProfileLogic {
  final CompanyService _service;

  CompanyProfileLogic({CompanyService? service})
      : _service = service ?? CompanyService();

  Future<bool> isAdmin() => _service.checkIsMatrixAdmin();

  Stream<CompanyProfileBundle> get companyStream =>
      _service.watchCompanyBundle();

  Future<void> logScreenOpen(String screenName) =>
      analyticsService.logScreenView(screenName: screenName);

  Future<void> navigateToEdit(BuildContext context) async {
    await analyticsService.logEvent(name: 'open_edit_company_profile');
    if (!context.mounted) return;
    await AppNavigation.openEditCompanyProfile(context);
  }

  Future<void> saveProfile(Map<String, Object?> payload) =>
      _service.saveCompanyProfile(payload);
  Future<String> uploadImage({
  required File file,
  required String prefix,
  int maxWidth = 1080,
  int maxHeight = 1080,
  int quality = 75,
}) {
  return _service.uploadCompanyImage(
    file: file,
    prefix: prefix,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    quality: quality,
  );
}
}