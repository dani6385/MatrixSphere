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
}