import 'package:flutter/material.dart';

import '../../models/attendance_rule_model.dart';
import '../../models/company_profile_model.dart';

class CompanyProfileFormController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  void populateFromBundle(
    CompanyProfileModel company,
    AttendanceRuleModel rule,
  ) {
    nameController.text = company.name;
    emailController.text = company.email;
    phoneController.text = company.phone ?? '';
    addressController.text = company.address ?? '';
    descriptionController.text = company.description ?? '';
    radiusController.text = rule.radiusMeters?.round().toString() ?? '';
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    radiusController.dispose();
  }
}