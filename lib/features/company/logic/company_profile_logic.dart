import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';

import '../services/company_service.dart';

class CompanyProfileLogic {
  final CompanyService _service;

  CompanyProfileLogic({CompanyService? service})
      : _service = service ?? CompanyService();

  Future<bool> isAdmin() => _service.checkIsMatrixAdmin();

  Stream<CompanyProfileBundle> get companyStream =>
      _service.watchCompanyBundle();

  void navigateToEdit(BuildContext context) {
    AppNavigation.openEditCompanyProfile(context);
  }
}